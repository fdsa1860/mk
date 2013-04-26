% class Tracklet
% each node has two properties
% fr: frameNo
% bb: bounding box


classdef Tracklet
    
    properties
        node;
        color;
    end
    
    methods
        % Constructor
        function obj = Tracklet(frameNo,bb,c)
            obj.node = struct('fr',frameNo,'bb',bb);
            obj.color = c;
        end
        % Function add: add on node to the current tracklet
        function obj = add(obj,frameNo,bb,c)
            obj.node = [obj.node; struct('fr',frameNo,'bb',bb)];
            obj.color = c;
        end
        
    end
    
end