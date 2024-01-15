# Terraform and AWS

This follows the tutorial from Terraform where they create a simple AWS instance.

But I'm adding more to it! :D

# Analogy

Think of your VPC like a large piece of land (say, a big park) that you've bought to develop. This land is divided into plots (subnets). The entire park's address range is like the VPC's IP address range.

The CIDR block for the VPC (10.0.0.0/16, for example) defines the total number of plots (IP addresses) you can have in your park. The /16 part is like saying, "In this park, I can create up to 65,536 plots."

Within your park, you might want to have different areas for specific purposes – a playground, a picnic area, a pond, etc. These are like subnets – smaller, dedicated sections of your park (VPC).

Inside a playground, you might have a sandbox, a swing set, and a slide. These are like the resources you create in your subnets – EC2 instances, RDS databases, etc.

When you "segment your VPC's IP address range into smaller blocks," you're essentially dividing the park into these smaller areas (subnets), each with its own specific range of addresses.

# Visualization

Some notes to not get confused, the visualization in Excalidraw was a quick one to show how it's setup:

- NACLs can be associated with multiple subnets. So if they have the same rules, it's redundant to create multiple NACLs.
- An ec2 instance can be attached to multiple security groups. So you could have one security group and multiple instances attached to it.
- `us-west-2b` wasn't implemented in the code, that's just to demonstrate if you had multiple subnets, you would typically have them in different availability zones.

# VPC

A VPC is a virtual network dedicated to your AWS account, isolated from other virtual networks in the AWS cloud. It's where you launch AWS resources, like EC2 instances. It provides control over your virtual networking environment, including IP address ranges, subnets, route tables, and network gateways.

## When to use it?

1. **You Want Your Own Private Space in the Cloud**: A VPC is like having a piece of the cloud all to yourself. You can set it up the way you want, just like your own private section of the internet.

2. **Keeping Things Safe and Secure**: If you want to make sure only the people or systems you choose can access your cloud resources, a VPC helps you do that. It's like putting a fence around your cloud resources.

3. **Running Different Projects or Stages**: If you have different projects or stages like testing and final versions, a VPC helps keep them separate and organized.

4. **Meeting Special Rules for Your Data**: Sometimes, there are special rules about how and where you can store and handle data, especially if it's sensitive information. A VPC can help meet those rules.

5. **Connecting the Cloud to Your Own Network**: If you need to connect your cloud resources to your company's network, a VPC can be set up to do this smoothly.

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

## Relationship in VPC Architecture

- **Layered Security**: Using both NACLs and Security Groups provides layered security within your AWS infrastructure. NACLs provide a broad level of control at the subnet level, while Security Groups offer granular control at the instance level.
- **Complementary**: Both work in complement to each other. While NACLs serve as a first line of defense at the subnet level, Security Groups provide a more finely tuned form of security at the instance level.

# Stateless vs Stateful (NACLs vs Security Groups)

## NACLs

Network ACLs are stateless, meaning they do not keep track of the state of network connections. Each packet passing through an ACL is evaluated independently, without considering any previous packet, even if it's part of the same connection.

### Rules

Network ACLs contain a list of rules, and each rule is assigned a unique number (e.g., 100, 200, 300, and so on).

These numbers determine the order in which the rules are evaluated. Rules with lower numbers are evaluated before those with higher numbers.

### Rules evaluation

When network traffic attempts to enter or exit a subnet, the Network ACL evaluates this traffic against its list of rules to decide whether to allow or deny the traffic.

A "packet" refers to a unit of data being transmitted. Each packet has attributes like protocol (TCP, UDP, etc.), source IP address, destination IP address, source port, and destination port.

The ACL rules define criteria based on these attributes. For example, a rule might allow TCP traffic from source IP 203.0.113.5 to destination port 80.

### First rule that matches

The first rule in the list that matches the attributes of the traffic (like protocol, source IP, etc.) determines the action (allow or deny).

If a packet matches a rule, the ACL takes the corresponding action immediately, without evaluating the rest of the rules.

If no rule matches, the default action is to deny the traffic, as Network ACLs have an implicit deny rule at the end.

### Example

Suppose you have the following rules in a Network ACL:

- Rule #100: Allow TCP traffic on port 80 (HTTP) from any source.
- Rule #200: Deny all TCP traffic from IP address 192.0.2.1.

If an HTTP request arrives from IP address 192.0.2.1, it first hits Rule #100, which matches because it's HTTP traffic on port 80. The packet is allowed, and Rule #200 is not evaluated for this packet. If non-HTTP traffic arrives from 192.0.2.1, it doesn't match Rule #100 and goes to Rule #200, where it's denied.

## Security Groups

Security Groups are stateful, meaning that they automatically allow return traffic for allowed inbound traffic, and vice versa for outbound traffic. This means if an inbound rule allows traffic, the response traffic for that session is automatically allowed, regardless of outbound rules.

## Example

Imagine you have a VPC with a public subnet hosting a web server and a private subnet with a database server. You would use both Network ACLs and Security Groups to secure these resources:

- **Network ACL for Public Subnet**: You might configure the Network ACL to allow inbound HTTP and HTTPS traffic (ports 80 and 443) to reach the web server and deny all inbound traffic to the private subnet. For outbound, you might allow responses to HTTP/HTTPS requests and essential outbound traffic like DNS queries. Because ACLs are stateless, you need to explicitly allow both inbound and outbound traffic.

- **Network ACL for Private Subnet**: This could be configured to deny all inbound traffic from outside the VPC and only allow traffic from the public subnet (where the web server is) on specific ports required for database access. Outbound rules might be set to allow traffic to the public subnet and essential services like updates.

- **Security Group for Web Server**: A Security Group attached to the web server EC2 instance might allow inbound HTTP and HTTPS traffic and any other necessary services like SSH. It would allow outbound traffic as needed. Due to its stateful nature, return traffic for allowed inbound connections is automatically permitted.

- **Security Group for Database Server**: This Security Group might only allow inbound traffic on the database port from the web server's Security Group, ensuring that only the web server can communicate with the database.

## Stateful vs Stateless clarified

**Stateful:** The system remembers the state of previous network connections or packets.

- When a request is allowed through a security group (inbound rule), the response to that request is automatically allowed, regardless of outbound rules.
- If an inbound rule allows HTTP traffic (port 80) to an EC2 instance, the outbound responses to those HTTP requests are automatically allowed, even if there's no specific outbound rule for HTTP. Even if you deny all outbound traffic, the responses to allowed inbound traffic are still allowed to exit.

**Stateless:** The system does not retain any memory of previous network connections or packets.

- Each packet is evaluated independently without considering any prior packets or connections.
- You need to define both inbound and outbound rules explicitly. A response packet must match an outbound rule to be allowed, regardless of the inbound rules.
- If you have an inbound rule in a Network ACL allowing HTTP requests, you must also have a corresponding outbound rule to allow HTTP responses. Without the outbound rule, the responses won't be allowed through, even though the inbound requests were permitted.

## Positioning

NACLs are associated with a subnet, but it's more accurate to think of them as acting within the subnet rather than being in front of it. They control the traffic flowing into and out of the subnet. NACLs apply their set of rules to all the traffic entering or exiting the subnet.

NACLs are not literally "in front" of the subnet in a physical sense but are an integral part of the subnet's traffic control mechanism.

Security Groups are applied directly to individual instances, such as EC2 instances. They act like a firewall at the instance level, controlling what traffic is allowed to reach the instance and what traffic can leave it.

# Elastic Load Balancer (ELB)

An ELB automatically distributes incoming application traffic across multiple targets, such as Amazon EC2 instances, in AWS. It improves the availability and scalability of your application by handling the traffic distribution, which ensures no single instance is overwhelmed. ELBs are often used to increase fault tolerance in applications, allowing for seamless redirection of traffic in case of instance failure or high load.
