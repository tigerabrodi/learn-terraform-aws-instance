# Terraform and AWS

This follows the tutorial from Terraform where they create a simple AWS instance.

But I'm adding more to it! :D

# Analogy

Think of your VPC like a large piece of land (say, a big park) that you've bought to develop. This land is divided into plots (subnets). The entire park's address range is like the VPC's IP address range.

The CIDR block for the VPC (10.0.0.0/16, for example) defines the total number of plots (IP addresses) you can have in your park. The /16 part is like saying, "In this park, I can create up to 65,536 plots."

Within your park, you might want to have different areas for specific purposes – a playground, a picnic area, a pond, etc. These are like subnets – smaller, dedicated sections of your park (VPC).

Inside a playground, you might have a sandbox, a swing set, and a slide. These are like the resources you create in your subnets – EC2 instances, RDS databases, etc.

When you "segment your VPC's IP address range into smaller blocks," you're essentially dividing the park into these smaller areas (subnets), each with its own specific range of addresses.

# VPC

A VPC is a virtual network dedicated to your AWS account, isolated from other virtual networks in the AWS cloud. It's where you launch AWS resources, like EC2 instances. It provides control over your virtual networking environment, including IP address ranges, subnets, route tables, and network gateways.

# Internet Gateway

The Internet Gateway serves as a bridge between your VPC and the internet. It allows communication between instances in your VPC and the outside world. It's essential for any resources in your VPC that need to interact with the internet, either to send outbound traffic or receive inbound traffic.

When you create an Internet Gateway and attach it to your VPC, it becomes a route target for internet-routable traffic. You would typically modify your VPC's route tables to direct all outbound traffic destined for the internet to the Internet Gateway.

In most cases, the configuration of the Internet Gateway is straightforward: you create it and attach it to your VPC. There are no additional configurations or settings at the gateway level itself. The main configurations are done in the route tables of your VPC, where you specify what traffic goes through the Internet Gateway.

# Subnet

Subnets are subdivisions you create within a VPC. They allow you to segment your VPC's IP address range into smaller blocks, which can be useful for organizing and securing resources.

# CIDR

CIDR stands for Classless Inter-Domain Routing. A CIDR block is a method for allocating IP addresses and routing IP packets. It's represented by an IP address and a suffix (like /16, /24) that indicates the size of the network.

When you create a VPC, you specify a CIDR block (e.g., 10.0.0.0/16). This determines the entire range of IP addresses available within your VPC. In this case, the /16 suffix indicates a large range of IP addresses (65,536 addresses).

## Block Syntax

A CIDR block like 10.0.0.0/16 combines an IP address (10.0.0.0) with a suffix (/16). The IP address marks the start of a range, and the suffix indicates how large that range is.

The Suffix (/16, /24, etc.): This number represents the subnet mask length and tells you how many IP addresses are in that range. A /16 gives you 65,536 addresses, while a /24 gives you 256 addresses.

VPC CIDR (10.0.0.0/16): This is like saying, "My park starts at address 10.0.0.0 and includes 65,536 plots."

Subnet CIDR (10.0.1.0/24): This is more specific. It's like saying, "In my park, the picnic area starts at address 10.0.1.0 and has 256 plots." The 1 in 10.0.1.0 is like specifying a particular section of the park, differentiating it from other areas.

## Subnet

Subnets are carved out of the VPC's CIDR block. For example, a subnet with a CIDR block of 10.0.1.0/24 is part of the larger VPC CIDR block. The /24 suffix indicates a smaller range of IP addresses (256 addresses), suitable for a smaller group of resources.

# Where instance is located?

VPC -> Subnet -> Instance.

EC2 instance resides in a subnet, which is part of your VPC. The subnet's CIDR block determines the IP address range available to instances within it.

# What and why IP addresses?

CIDR blocks provide a way to allocate and manage IP addresses in a network. Each block represents a range of IP addresses.

An IP address within a CIDR block is like a specific address (like a house number in a street). In networking, each device or resource (like an EC2 instance or a database in AWS) needs an IP address to communicate with other devices.

CIDR also involves routing. Routing is the process of directing data (IP packets) across a network. CIDR blocks help in defining routes by grouping addresses together, making it easier to direct traffic.

# Terraform taint

If you need to mark a resource as tainted, you can use the terraform taint command. This means that the next time you run terraform apply, the resource will be destroyed and recreated.

# Security Groups

Imagine your AWS Virtual Private Cloud (VPC) as an exclusive club in the cloud city. Within this club (VPC), you have different rooms (subnets), each hosting different types of events or services. Now, to keep these rooms safe and ensure only the right guests (traffic) get in, you have bouncers at the door of each room. These bouncers are your AWS Security Groups.

## What are Security Groups?

- **Definition**: Security Groups in AWS are like virtual bouncers or firewalls that control the inbound and outbound traffic for your instances (like servers or services).
- **Purpose**: Their main job is to ensure that only the traffic you want can get in or out of your instances.

## How Do They Work?

1. **Rules**: Each Security Group works by having a set of rules. These rules are like a list the bouncer has, detailing who's allowed in and who's allowed out.

   - **Inbound Rules**: Determine who can enter (which incoming network requests can be accepted).
   - **Outbound Rules**: Decide who can leave (which outgoing network requests can be made).

2. **Assignment**: You can assign a Security Group to multiple instances within your AWS VPC. However, an instance can be associated with multiple Security Groups.

3. **Default Settings**: By default, a new Security Group allows no inbound traffic (no one gets in) and allows all outbound traffic (everyone can leave).

## Their Role in VPC and Subnets

- **Within VPC**: In your AWS VPC, Security Groups act as the first line of defense for your instances. They ensure that only authorized network traffic as per your rules can access these instances.
- **Across Subnets**: Even if you have different subnets for different purposes (like one for your web servers and another for your database), Security Groups help in managing traffic within these subnets. They can be configured to allow specific traffic between these subnets, maintaining both connectivity and security.

## Key Points to Remember

1. **Stateful Nature**: If an instance in your VPC sends a request, the response to this request is allowed back in, regardless of inbound rules. This is because Security Groups are stateful - they remember and allow return traffic automatically.
2. **Instance Level Security**: Unlike Network Access Control Lists (NACLs) that operate at the subnet level, Security Groups provide security at the instance level.
3. **No 'Deny' Rules**: Security Groups only have 'allow' rules. If there’s no rule that explicitly allows a type of traffic, it’s automatically denied.

## Analogy Recap

- **VPC**: The club.
- **Subnets**: Different rooms in the club.
- **Security Groups**: Bouncers at the doors of each room, controlling who gets in and out based on the guest list (rules).

# Network Access Control Lists (NACLs)

- **Subnet Level**: NACLs function at the subnet level within a VPC.
- **Functionality**:
  - They act as a firewall for controlling traffic entering and leaving the subnet.
  - NACLs evaluate traffic attempting to enter or leave any instance within the subnet.
- **Stateless**: NACLs are stateless, meaning they treat each packet separately. Inbound and outbound traffic rules must be explicitly defined. For instance, if you allow inbound HTTP traffic, you must also explicitly allow outbound HTTP responses.
- **Rule-Based**: NACLs use numbered rules to determine whether to allow or deny traffic. The lower the number, the higher the priority.
- **Default Settings**: By default, a new NACL allows all inbound and outbound traffic until rules are applied to restrict traffic.

### Relationship in VPC Architecture

- **Layered Security**: Using both NACLs and Security Groups provides layered security within your AWS infrastructure. NACLs provide a broad level of control at the subnet level, while Security Groups offer granular control at the instance level.
- **Complementary**: Both work in complement to each other. While NACLs serve as a first line of defense at the subnet level, Security Groups provide a more finely tuned form of security at the instance level.
