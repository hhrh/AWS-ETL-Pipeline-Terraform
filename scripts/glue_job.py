import sys
import itertools
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, lit, create_map, explode, to_date, date_format
from pyspark.sql.types import StructType, StructField, StringType

from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.context import SparkContext


# Handle job arguments
args = getResolvedOptions(sys.argv, ['JOB_NAME', 'input_path', 'output_path'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Input/output S3 locations
input_path = args['input_path']
output_path = args['output_path']

# Schema
record_schema = StructType([
    StructField("1. open", StringType(), True),
    StructField("2. high", StringType(), True),
    StructField("3. low", StringType(), True),
    StructField("4. close", StringType(), True),
    StructField("5. volume", StringType(), True),
])

time_series_col = "Time Series (5min)"
meta_symbol_col = "`Meta Data`.`2. Symbol`"

# Read raw JSON
df_raw = spark.read.option("multiLine", True).json(input_path)

# Extract symbol and struct
df_meta = df_raw.withColumn("symbol", col(meta_symbol_col))

ts_field_names = df_meta.select(time_series_col).schema[0].dataType.names

map_entries = []
for ts in ts_field_names:
    map_entries.append(lit(ts))
    map_entries.append(col(f"`{time_series_col}`.`{ts}`").cast(record_schema))

df_map = df_meta.select(
    col("symbol"),
    create_map(*map_entries).alias("ts_map")
)

df_exploded = df_map.select(
    col("symbol"),
    explode("ts_map").alias("timestamp", "data")
)

df_clean = df_exploded.filter(col("data").isNotNull()).select(
    col("symbol"),
    date_format("timestamp", "yyyy-MM-dd HH:mm:ss").alias("timestamp"),
    col("data.`1. open`").alias("open"),
    col("data.`2. high`").alias("high"),
    col("data.`3. low`").alias("low"),
    col("data.`4. close`").alias("close"),
    col("data.`5. volume`").alias("volume")
).withColumn("date", to_date("timestamp"))

# Write output partitioned by symbol/date
spark.conf.set("spark.sql.sources.partitionOverwriteMode", "dynamic")
print(f"Final record count: {df_clean.count()}")
df_clean.show(5, truncate=False)

df_clean.write.mode("overwrite").partitionBy("symbol", "date").parquet(output_path)

job.commit()
