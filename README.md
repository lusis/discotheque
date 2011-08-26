# Discotheque

>> "This disco used to be a cute cathedrale" -- Steve Taylor

Discotheque is aiming to be a general purpose node discovery tool.

It was inspired by the ZenDiscovery functionality of ElasticSearch, originally the [EC2 discovery code](https://github.com/elasticsearch/elasticsearch/blob/master/plugins/cloud/aws/src/main/java/org/elasticsearch/discovery/ec2/AwsEc2UnicastHostsProvider.java)

When initially setting up our ElasticSearch clusters, I was amazed at how "magical" it was at finding other ES nodes on EC2. Curiosity got the better of me...
Originally this was going to be just a single hack for porting that logic but I've decided to go a bit further.

## The plan
Right now this is a really ghetto MVP. Given a list of any combination of these filters:

- "sg" security group
- "ami" ami id
- "az" availability zone
- "arch" architecture

You'll get back a list of matching nodes. It's up to you to decide what to do with them. 

The way it currently works is by getting information about the node it's currently running on via EC2 metadata calls. From there, it uses that information to populate the filters.

So if your node is in us-east-1a, running `Discotheque::Discover` with an `az` filter, will give you all the nodes in your availability zone. 

Long term, there will be mutliple different discovery methods - unicast, multicast, ec2..you name it. Additionally, you'll be able to specify a "test" criteria to further pare down the list. Also the plan is to provide a mixin when you can make your application "discoverable" - say responding to a given port request with a fingerprint.

## Example usage (kind of pointless at this early of a stage)
__Again, you'll need to be on an EC2 node. I'll resolve this in the future__

```ruby
c = Discotheque::Discover.new
c.get_nodes :access_key_id => "YYYYYYYYYYYYYYYYYYYY", :secret_access_key => "XXXXXXXXXXXXXXXXXXXXXXXXXX"
# pretty much returns all nodes since there are no filters
# ["1.1.1.1", "2.2.2.2", "3.3.3.3", "4.4.4.4"]
c.filters << "sg"
c.get_nodes :access_key_id => "YYYYYYYYYYYYYYYYYYYY", :secret_access_key => "XXXXXXXXXXXXXXXXXXXXXXXXXX"
# ["1.1.1.1", "2.2.2.2", "3.3.3.3"]
c.filters << "ami"
# ["2.2.2.2", "3.3.3.3"]
c.filters
# ["ami", "sg"]
c.clear_filters
# []
# If you want to see what Discotheque knows about the node it's running on
m = Discotheque::Metadata.new
#<Discotheque::Metadata:0x00000000fb1008
# @availability_zone="us-east-1a",
# @group_name="default",
# @image_id="ami-221fec4b">
```

If you pass in `true` to the constructor you'll get the mock data above


