# quorum-installation

[JPMorganChase Quorum](https://github.com/jpmorganchase/quorum)

Extracted from [7nodes Example](https://github.com/jpmorganchase/quorum-examples/tree/master/examples/7nodes) for a single node installation.

Supported machine : Ubuntu

Incoming ports : 21000, 22000, 50401, 9001

Project structure : same as in the 7nodes example for a single node: qdata/dd1, qdata/c1, qdata/logs

Steps to deploy quorum 

1) 		git clone https://github.com/biplavosti/Quorum.git


2) Installation : Golang, Java, Quorum, Tessera and other libraries (note user input is required when installing Java, and some other libraries)
		
		bash bootstrap.sh
        
  	In step 3 __geth not found__ error might shows up. So, better logout and re-login.

3) Initialize blockchain, generate node key, tessera keys and config file

		bash raft-init.sh
        
   The _enode hash_ is printed on terminal. Or check the _nodekey_ file in _qdata/dd1/geth/_ directory and convert it to enodehash. 
   
 	Add the enode url in the permission-nodes.json (sample enode urls is preloaded in the file - remove them) in all the nodes.

4) Copy permissioned-nodes.json to working directory
		
        cp permissioned-nodes.json qdata/dd1/permissioned-nodes.json
        
        cp permissioned-nodes.json qdata/dd1/static-nodes.json
   
	
5) Add Tessera peers url in __qdata/c1/tessera_config.json__ in all nodes.

	Follow above commands and procedures in all the nodes before proceeding further. After all the required nodes are set up proceed to 6)

6) Start node and teserra

		bash raft-start.sh




If more nodes are needed to add in an existing blockchain system :
    
a) follow above steps upto 3 to get enodehash of the new node
    
 b) Open Geth JS Console in any one of the already connected node and run :
    		
            	raft.addPeer(enode_url)
                
   
   This will return the raft id of the new node.
    
   c) open raft_start.sh, add following parameter in the geth command
    		
            --raftjoinexisting raftid

d) Add enode url in the permissioned-nodes.json in all nodes.

e) follow steps 5 and 6