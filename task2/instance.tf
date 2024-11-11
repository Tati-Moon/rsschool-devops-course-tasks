resource "aws_instance" "public_instances" {
  count = length(var.public_subnet_cidrs)

  ami           = var.ec2_ami_amazon_linux
  instance_type = var.ec2_instance_type
  key_name      = var.ssh_key_name

  subnet_id                   =  element(aws_subnet.public_subnet[*].id, count.index)
  vpc_security_group_ids      = [aws_security_group.public_instance.id]
  associate_public_ip_address = true

   tags = {
    Name = "Public Instance  ${count.index + 1}"
    Environment = "Development"
  }
}

resource "aws_instance" "private_instances" {
  count = length(var.private_subnet_cidrs)

  ami           = var.ec2_ami_amazon_linux
  instance_type = var.ec2_instance_type
  key_name      = var.ssh_key_name

  subnet_id                   =  element(aws_subnet.private_subnet[*].id, count.index)
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_icmp.id
  ]
  associate_public_ip_address = true

   tags = {
    Name = "Private Instance  ${count.index + 1}"
    Environment = "Development"
  }
}

resource "aws_instance" "bastion_host" {
  ami           = var.ec2_ami_amazon_linux
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.public_subnet[0].id
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_icmp.id
  ]
  key_name = var.ssh_key_name
  tags = {
    Name = "Bastion Host"
  }
}

resource "aws_instance" "k3s_instance" {
  count         = length(var.public_subnet_cidrs)
  ami           = var.ec2_ami_amazon_linux
  instance_type = var.ec2_instance_type
  subnet_id     = element(aws_subnet.private_subnet[*].id, count.index)
  key_name      = var.ssh_key_name

  vpc_security_group_ids = [
    aws_security_group.k3s.id]

  tags = {
    Name = "K3s instance ${count.index + 1}"
  }

  user_data = <<-EOF
              #!/bin/bash
              # Включаем поддержку SELinux
              sudo amazon-linux-extras enable selinux-ng
              
              # Устанавливаем целевую политику SELinux
              sudo yum install selinux-policy-targeted -y

              # Устанавливаем K3s - легковесный дистрибутив Kubernetes
              curl https://get.k3s.io | sh -
              
              # Проверяем статус службы K3s
              sudo systemctl status k3s

              # Создаем символическую ссылку для удобства доступа к K3s
              sudo ln -s /usr/local/bin/k3s /usr/bin/k3s

              # Создаем каталог для конфигураций Kubernetes
              mkdir -p ~/.kube

              # Копируем конфигурацию K3s в каталог .kube
              sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config

              # Устанавливаем права доступа для конфигурационного файла
              sudo chmod 600 ~/.kube/config

              # Добавляем переменную окружения KUBECONFIG в .bashrc
              echo 'export KUBECONFIG=~/.kube/config' >> ~/.bashrc
              # Перезагружаем настройки bash
              source ~/.bashrc

             # Выводим информацию о каталоге .kube
              ls -ld /home/ec2-user/.kube
              # Выводим информацию о конфигурационном файле
              ls -l /home/ec2-user/.kube/config
              # Изменяем владельца каталога .kube на текущего пользователя
              sudo chown -R ec2-user:ec2-user /home/ec2-user/.kube

              # Выводим информацию о запущенных подах в пространстве имен kube-system
              kubectl get all -n kube-system
              # Выводим информацию о нодах в кластере
              kubectl get nodes

              # Применяем тестовый pod из примера Kubernetes
              kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml
              # Выводим информацию о запущенных подах
              kubectl get pods

              # Устанавливаем Grafana
              sudo yum install -y wget
              wget https://dl.grafana.com/oss/release/grafana-10.1.1-1.x86_64.rpm
              sudo yum install -y grafana-10.1.1-1.x86_64.rpm

              # Запускаем Grafana
              sudo systemctl start grafana-server
              sudo systemctl enable grafana-server
              
              # Проверка Grafana
              sudo systemctl status grafana-server
              sudo netstat -tuln | grep 3000

              EOF
}
