## 🎯 Septa AWS Project

Este proyecto personal consiste en la creación y despliegue de una webapp a través de una imagen Docker que es enviada hacia un repositorio ECR donde posteriomente el servicio de ECS creará los contenedores necesarios para permitir al usuario final
acceder a la web correctamente.

### 🏛️ Arquitectura

Para garantizar la resiliencia y la eficiencia, la infraestructura se ha diseñado con los siguientes pilares:

* **Alta Disponibilidad Multi-AZ**: El Application Load Balancer (ALB) está distribuido en dos redes públicas en zonas de disponibilidad (AZ) distintas dentro de la región eu-west-1, garantizando que el tráfico se mantenga operativo incluso ante la caída de una zona de datos completa.
* **Seguridad en Redes Privadas**: Los contenedores de ECS (Fargate) residen en subredes privadas sin acceso directo a internet, reduciendo drásticamente el acceso indeseado desde el exterior.
* **VPC Endpoints**: La comunicación desde los contenedores hacia los servicios de AWS se realiza desde VPC Endpoints, garantizando la funcionalidad y ahorrando costes al no escoger para esta función un NAT Gateway.
* **Observabilidad Integrada**: Implementación de logs centralizados en CloudWatch mediante un endpoint dedicado, permitiendo un monitoreo en tiempo real sin exponer el tráfico a la red pública.

### 🛠️ Stack Tecnológico

* **IaC (Infrastructure as Code):** Terraform
* **Orquestación y CI/CD:** GitHub Actions
* **Container:** Docker