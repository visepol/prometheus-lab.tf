variable "region" {
  description = "Define qual região será lançada"
  default     = "sa-east-1"
}

variable "name" {
  description = "Nome do Serviço"
  default     = "prometheus"
}

variable "env" {
  description = "O ambiente do Serviço"
  default     = "production"
}

variable "ami" {
  description = "AWS AMI que será utilizada"
  default     = "ami-0895310529c333a0c"
}

variable "instance_type" {
  description = "Tipo de instância AWS. Define o configuração do hardware da máquina"
  default     = "t2.micro"
}

variable "repository" {
  description = "Repositório do IAC"
  default     = "https://github.com/visepol/prometheus-tf"
}
