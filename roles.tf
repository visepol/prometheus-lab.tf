#Instance Role
resource "aws_iam_role" "ssm_role" {
  name               = "ssm-ec2"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name    = "ssm-ec2-prometheus"
    Service = "prometheus"
  }
}

#Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-prometheus-profile"
  role = aws_iam_role.ssm_role.id
}

#Attach Policies to Instance Role
resource "aws_iam_policy_attachment" "attach_ssm_policy" {
  name       = "attachment-ssm"
  roles      = [aws_iam_role.ssm_role.id]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
