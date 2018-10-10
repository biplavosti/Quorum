# quorum-installation

Steps to deploy quorum 

1) Clone this repository on your local machine 

		git clone https://github.com/biplavosti/Quorum.git

2) Step 1 create a directory 'Quorum'. It has scripts to deploy the quorum node on your machine
		
		cd Quorum

3) Run following commands to set up the node

		bash bootstrap.sh
	
		bash raft-init.sh	- enode url for this node is printed on console. Since this is a permissioned blockchain, we will require to add this enode in permissioned nodes list.

4) To start the node run 

		bash raft-start.sh
	