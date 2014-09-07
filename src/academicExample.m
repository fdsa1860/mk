% generate academic data for network id

rej=1920; %randomizer
nodes=8;
frames=50;

[W C]=VARsimulate(frames,nodes,2,rej);