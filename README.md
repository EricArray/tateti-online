# Commands
To upload Linux dedicated server:

scp -i '.\My key pair for Godot Test.pem' C:\Users\ernok\Documents\online-ta-te-ti\bin\linux-dedicated-server\tateti-dedicated-server.pck ec2-user@ec2-18-116-231-238.us-east-2.compute.amazonaws.com:/home/ec2-user

To start the server:

ssh -i '.\My key pair for Godot Test.pem' ec2-user@ec2-18-116-231-238.us-east-2.compute.amazonaws.com

nohup ./Godot_v4.2.1-stable_linux.x86_64 --main-pack tateti-dedicated-server.pck --headless &
