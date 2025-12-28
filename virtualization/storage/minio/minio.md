# **[](https://github.com/minio/minio)**

MinIO is a high-performance, S3-compatible object storage solution released under the GNU AGPL v3.0 license. Designed for speed and scalability, it powers AI/ML, analytics, and data-intensive workloads with industry-leading performance.

🔹 S3 API Compatible – Seamless integration with existing S3 tools 🔹 Built for AI & Analytics – Optimized for large-scale data pipelines 🔹 High Performance – Ideal for demanding storage workloads.

AI storage documentation (<https://min.io/solutions/object-storage-for-ai>).

This README provides quickstart instructions on running MinIO on bare metal hardware, including container-based installations. For Kubernetes environments, use the MinIO Kubernetes Operator.

Container Installation
Use the following commands to run a standalone MinIO server as a container.

Standalone MinIO servers are best suited for early development and evaluation. Certain features such as versioning, object locking, and bucket replication require distributed deploying MinIO with Erasure Coding. For extended development and production, deploy MinIO with Erasure Coding enabled - specifically, with a minimum of 4 drives per MinIO server. See **[MinIO Erasure Code Overview](https://min.io/docs/minio/linux/operations/concepts/erasure-coding.html)** for more complete documentation.

Stable
Run the following command to run the latest stable image of MinIO as a container using an ephemeral data volume:

podman run -p 9000:9000 -p 9001:9001 \
  quay.io/minio/minio server /data --console-address ":9001"
The MinIO deployment starts using default root credentials minioadmin:minioadmin. You can test the deployment using the MinIO Console, an embedded object browser built into MinIO Server. Point a web browser running on the host machine to <http://127.0.0.1:9000> and log in with the root credentials. You can use the Browser to create buckets, upload objects, and browse the contents of the MinIO server.

You can also connect using any S3-compatible tool, such as the MinIO Client mc commandline tool. See Test using MinIO Client mc for more information on using the mc commandline tool. For application developers, see <https://min.io/docs/minio/linux/developers/minio-drivers.html> to view MinIO SDKs for supported languages.
