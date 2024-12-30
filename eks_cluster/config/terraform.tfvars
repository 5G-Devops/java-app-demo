region = ""
access_key = ""
secret_key = "" 


# define the map for inputs
# define input values as a map
vpc_config = {

vpc01 = {
vpc_cidr_block = "192.168.0.0/16"
tags = {
    "Name" = "my_vpc"
}
}
}

subnet_config = {
    "public-ap-south-1a" = {
        vpc_name = "vpc01"
        availability_zone = "ap-south-1a"
        cidr_block = "192.168.0.0/18"
        tags = {
            "Name" = "public-ap-south-1a"
        }
       
    }
     "public-ap-south-1b" = {
        vpc_name = "vpc01"
        availability_zone = "ap-south-1b"
        cidr_block = "192.168.64.0/18"
        tags = {
            "Name" = "public-ap-south-1b"
        }
       
    }
    "private-ap-south-1a" = {
        vpc_name = "vpc01"
        availability_zone = "ap-south-1a"
        cidr_block = "192.168.128.0/18"
        tags = {
            "Name" = "private-ap-south-1a"
        }
       
    }
     "private-ap-south-1b" = {
        vpc_name = "vpc01"
        availability_zone = "ap-south-1b"
        cidr_block = "192.168.192.0/18"
        tags = {
            "Name" = "private-ap-south-1b"
        }
       
    }
}

internetGW_config = {
igw01 = {
    vpc_name = "vpc01"
    tags = {
        "Name" = "IGW"
    }
}
}

elastic_IP_config = {
eip01 = {
tags = {
    "Name" = "nat01"
}
}
eip02 = {
tags = {
    "Name" = "nat02"
}
}
}
nat_GW_config = {
    natgw01 = {
        eip_name = "eip01"
        subnet_name = "public-ap-south-1a"
        tags = {
            "Name" = "natGW01"
        }
    }
    natgw02 = {
        eip_name = "eip02"
        subnet_name = "public-ap-south-1b"
        tags = {
            "Name" = "natGW02"
        }
    }

}

route_table_config = {
RT01 = {
    private = 0
  vpc_name = "vpc01"
  gateway_name = "igw01"
  tags = {
    "Name" = "public_route"
  }
}
RT02 = {
     private = 1
   vpc_name = "vpc01"
  gateway_name = "natgw01"
  tags = {
    "Name" = "private_route"
  }
}
RT03 = {
     private = 1
  vpc_name = "vpc01"
  gateway_name = "natgw02"
  tags = {
    "Name" = "private_route"
  }
}
}
route_table_association_config = {
RT01Assoc = {
subnet_name = "public-ap-south-1a"
route_table_name = "RT01" 
}
RT02Assoc = {
subnet_name = "public-ap-south-1b"
route_table_name = "RT01" 
}
RT03Assoc = {
subnet_name = "private-ap-south-1a"
route_table_name = "RT02"  
}
RT04Assoc = {
subnet_name = "private-ap-south-1b"
route_table_name = "RT03"
}
}

aws_eks_cluster_config = {
"demo-cluster"= {
eks_cluster_name = "demo-cluster"
subnet1 = "public-ap-south-1a"
subnet2 = "public-ap-south-1b"
subnet3 = "private-ap-south-1a"
subnet4 = "private-ap-south-1b"

tags = {
    "Name" = "demo-cluster"
}
}
}
aws_eks_node_group_config = {
node1 = {
node_group_name = "node1"
eks_cluster_name = "demo-cluster"
node_iam_role = "eks-node-general1"
subnet1 = "public-ap-south-1b"
subnet2 = "private-ap-south-1b"
tags = {
    "Name" = "node1"
}
    }
node2 = {
node_group_name = "node2"
eks_cluster_name = "demo-cluster"
node_iam_role = "eks-node-general1"
subnet1 = "public-ap-south-1b"
subnet2 = "private-ap-south-1b"
tags = {
    "Name" = "node2"
}
    }
}
