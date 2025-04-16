#Docker Swarm Master/Manager Servers
resource "aws_instance" "master-1" {
  ami                         = var.ami
  availability_zone           = "us-east-1a"
  instance_type               = "t2.micro"
  key_name                    = "LaptopKey"
  subnet_id                   = aws_subnet.subnet1-public.id
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
  associate_public_ip_address = true
  tags = {
    Name       = "swarm-master-1"
    Env        = "Prod1"
    Owner      = "afroz"
    CostCenter = "ABCD3"
  }
}

resource "aws_instance" "master-2" {
  #ami                         = data.aws_ami.my_ami.id
    ami                       = var.ami
  availability_zone           = "us-east-1a"
  instance_type               = "t2.micro"
  key_name                    = "LaptopKey"
  subnet_id                   = aws_subnet.subnet1-public.id
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
  associate_public_ip_address = true
  tags = {
    Name       = "swarm-master-2"
    Env        = "Prod"
    Owner      = "afroz
    CostCenter = "ABCD"
  }
}

resource "aws_instance" "master-3" {
  #ami                         = data.aws_ami.my_ami.id
    ami = var.ami
  availability_zone           = "us-east-1a"
  instance_type               = "t2.micro"
  key_name                    = "LaptopKey"
  subnet_id                   = aws_subnet.subnet1-public.id
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
  associate_public_ip_address = true
  tags = {
    Name       = "swarm-master-3"
    Env        = "Prod"
    Owner      = "afroz
    CostCenter = "ABCD"
  }
}

#Docker Swarm Worker Servers
resource "aws_instance" "worker-1" {
  #ami                         = data.aws_ami.my_ami.id
    ami = var.ami
  availability_zone           = "us-east-1a"
  instance_type               = "t2.micro"
  key_name                    = "LaptopKey"
  subnet_id                   = aws_subnet.subnet1-public.id
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
  associate_public_ip_address = true
  tags = {
    Name       = "swarm-worker-1"
    Env        = "Prod"
    Owner      = "afroz
    CostCenter = "ABCD"
  }
}

resource "aws_instance" "worker-2" {
  #ami                         = data.aws_ami.my_ami.id
  ami = var.ami
  availability_zone           = "us-east-1a"
  instance_type               = "t2.micro"
  key_name                    = "LaptopKey"
  subnet_id                   = aws_subnet.subnet1-public.id
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
  associate_public_ip_address = true
  tags = {
    Name       = "swarm-worker-2"
    Env        = "Prod"
    Owner      = "afroz
    CostCenter = "ABCD"
  }
}

# resource "aws_instance" "worker-3" {
#   #ami                         = data.aws_ami.my_ami.id
#   ami = var.ami
#   availability_zone           = "us-east-1a"
#   instance_type               = "t2.micro"
#   key_name                    = "LaptopKey"
#   subnet_id                   = aws_subnet.subnet1-public.id
#   vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
#   associate_public_ip_address = true
#   tags = {
#     Name       = "swarm-worker-3"
#     Env        = "Prod"
#     Owner      = "afroz
#     CostCenter = "ABCD"
#   }
# }

# resource "aws_instance" "worker-4" {
#   #ami                         = data.aws_ami.my_ami.id
#     ami = var.ami
#   availability_zone           = "us-east-1a"
#   instance_type               = "t2.micro"
#   key_name                    = "LaptopKey"
#   subnet_id                   = aws_subnet.subnet1-public.id
#   vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
#   associate_public_ip_address = true
#   tags = {
#     Name       = "swarm-worker-4"
#     Env        = "Prod"
#     Owner      = "afroz
#     CostCenter = "ABCD"
#   }
# }

# resource "aws_instance" "worker-5" {
#   #ami                         = data.aws_ami.my_ami.id
#     ami = var.ami
#   availability_zone           = "us-east-1a"
#   instance_type               = "t2.micro"
#   key_name                    = "LaptopKey"
#   subnet_id                   = aws_subnet.subnet1-public.id
#   vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
#   associate_public_ip_address = true
#   tags = {
#     Name       = "swarm-worker-5"
#     Env        = "Prod"
#     Owner      = "afroz
#     CostCenter = "ABCD"
#   }
# }

