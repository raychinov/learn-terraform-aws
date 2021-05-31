resource "aws_instance" "blue" {
  count = var.enable_blue_env ? var.blue_instance_count : 0
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.public_subnets[count.index % length(module.vpc.public_subnets)]
  vpc_security_group_ids = [module.app_security_group.this_security_group_id]
  associate_public_ip_address = true
  key_name      = aws_key_pair.generated_key.key_name
  user_data = templatefile("${path.module}/init-script.sh", {
    efs_ip = "${aws_efs_mount_target.mount.ip_address}"
    srv_index = "${count.index}"
    mysqlhost = "${aws_db_instance.mysql.address}"
    mysqldb = "${aws_db_instance.mysql.name}"
    mysqluser = "${aws_db_instance.mysql.username}"
    mysqlpass = "${aws_db_instance.mysql.password}"
    siteurl = "${aws_lb.app.dns_name}"
    wp_post = file("wp_post.txt")
    optimize_script = data.template_file.optimize.rendered

  })
  depends_on = [aws_efs_mount_target.mount]
  tags = {
    Name = "version-1.0-${count.index}"
  }
}
data "template_file" "optimize" {
  template = file("optimize.sh")
  vars = {
    db_port = aws_db_instance.mysql.port
    db_host = aws_db_instance.mysql.address
    db_user = aws_db_instance.mysql.username
    db_pass = aws_db_instance.mysql.password
    db_name = aws_db_instance.mysql.name
  }
}


resource "aws_lb_target_group" "blue" {
  name     = "blue-tg-${random_pet.app.id}-lb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    port     = 80
    protocol = "HTTP"
    timeout  = 5
    interval = 10
  }
}

resource "aws_lb_target_group_attachment" "blue" {
  count            = length(aws_instance.blue)
  target_group_arn = aws_lb_target_group.blue.arn
  target_id        = aws_instance.blue[count.index].id
  port             = 80
}

