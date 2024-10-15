CREATE CATALOG bqms WITH (
 'type'='iceberg',
 'warehouse'='gs://my-dw-bucket/flinkcdc',
 'catalog-impl'='org.apache.iceberg.gcp.bigquery.BigQueryMetastoreCatalog',
 'gcp_project'='forrest-test-project-333203',
 'gcp_location'='us-central1'
)
;