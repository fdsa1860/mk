

classdef Tracklet
    properties
        node;
    end
    methods
        function obj = Tracklet(frameNo,bb)
            obj.node = struct('fr', frameNo,'bb',bb);
        end
        
        function obj = add(obj,frameNo,bb)            
            obj.node = [obj.node; struct('fr', frameNo,'bb',bb)];
        end
    end
    
    
end