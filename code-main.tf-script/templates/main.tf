module "captain" {
  iam_role_to_assume = "arn:aws:iam::1234567890:role/glueops-captain-role"
  source             = "git::https://github.com/GlueOps/terraform-module-cloud-aws-kubernetes-cluster.git"
  eks_version        = "1.27"
  csi_driver_version = "v1.23.0-eksbuild.1"
  vpc_cidr_block     = "10.65.0.0/26"
  region             = "us-west-2"
  availability_zones = ["us-west-2a", "us-west-2b"]
  node_pools = [
#    {
#      "ami_image_id" : "ami-0d62cf3c1488af0a3",
#      "instance_type" : "t3a.large",
#      "name" : "glueops-platform-node-pool-1",
#      "node_count" : 4,
#      "spot" : false,
#      "disk_size_gb" : 20,
#      "max_pods" : 110,
#      "ssh_key_pair_names" : [],
#      "kubernetes_labels" : {
#        "glueops.dev/role" : "glueops-platform"
#      },
#      "kubernetes_taints" : [
#        {
#          key    = "glueops.dev/role"
#          value  = "glueops-platform"
#          effect = "NO_SCHEDULE"
#        }
#      ]
#    },
#    {
#      "ami_image_id" : "ami-0d62cf3c1488af0a3",
#      "instance_type" : "t3a.large",
#      "name" : "clusterwide-node-pool-1",
#      "node_count" : 4,
#      "spot" : false,
#      "disk_size_gb" : 20,
#      "max_pods" : 110,
#      "ssh_key_pair_names" : [],
#      "kubernetes_labels" : {},
#      "kubernetes_taints" : []
#    }
  ]
  peering_configs = [
#    {
#    vpc_peering_connection_id = "pcx-0df92b5241651ba92"
#    destination_cidr_block = "10.69.0.0/26"
#    }
  ]
}