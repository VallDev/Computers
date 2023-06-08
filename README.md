# Computers
Basic API for creating and consulting characteristics of some computers. Language used is Golang.

To see diagram of architecture, please go to infrastructure directory, then architecture directory and download images.

To see my presentation of the project, please go infrastructure directory, then presentation directory.

To see terraform files and how was created the infrastructure of the project, please go to infrastructure directory, then terraform directory. The infrastructure is divided in four layers, each layer has its own terraform state in S3 bucket in AWS, and some files used here were hidden to preserve better practices. You might see which files are them watching .gitignore file.

In computer directory are the go files for computer application in golang.

Dockerfile Image size in ECR of AWS is almost 8MG.

Whole project was developed in DevOps Projects Labs from Softserve.

by Andrés Vallejo.

Thanks.
