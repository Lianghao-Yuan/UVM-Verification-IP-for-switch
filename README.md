# UVM-Verification-IP-for-switch  
A complete UVM verification IP for simple switch (router)  

Project name: UVM verification environment for simple switch    
Author: Lianghao Yuan   
Email: yuanlianghao@gmail.com   
Date: 06/26/2015  

Notice: the RTL code for switch in this project is provided by  
www.testbench.in

// ---------------------------------------                                             
1. Directory structure        
// ---------------------------------------                                
/agent:      Contains all verification IP for switch   
/doc:        Contains specification, test plan and coverage report  
/rtl:        Contains the rtl code for switch and a dummy switch (for debug only)  
/sim:        Contains the Makefile for simulation (for Synopsys VCS only)   
/uvm_tb:     Contains higher level components like env, sequence, test, testbench and an rtl_wrapper   

// ---------------------------------------                    
2. Usage                   
// ---------------------------------------   
a. Modification of Makefile

Change the UVM_HOME in line 4 to your UVM package location. 
Change UVM_VERBOSITY to either UVM_LOW (shows everything) or UVM_NONE (default, shows nothing). 

b. In /sim, type "make" to run basic test 

c. Run debug mode to show more coverage info like line, code, toggle etc. 
  
Modify the Makefile, line 36 to include desired coverage type (eg. -cm line+fsm+...).     
In /sim, type "make vcs_debug".      
In /sim, type "make run_test_debug".    
Then, to generate coverage report, type "make vcs_urg", the coverage report is in /sim/urgReport folder. 

d. To clean all auto-generated files, type "make clean".  
