
% MonkeyDetector class
% Created by Xikang Zhang, 06/24/2013

classdef MonkeyDetector
    properties
        posDir;
        negDir;
        modelName;
        parameters;
    end
    methods
        %----------------------------------------------
        % Constructor
        function obj = MonkeyDetector            
            obj.posDir = [];
            obj.negDir = [];
            obj.modelName = [];
            obj.parameters.scaleX = [0.5000 1];
            obj.parameters.scaleY = [0.5000 1];
            obj.parameters.winW_orig = 40;
            obj.parameters.winH_orig = 40;
            obj.parameters.winStepX = 10;
            obj.parameters.winStepY = 10;
            obj.parameters.nlevels = 10;
            obj.parameters.svm_thres = 0;
            obj.parameters.scaleStep = 1.1000;
            obj.parameters.merge_thres = 0;
            obj.parameters.w = [];
            obj.parameters.c = 0.1;
            obj.parameters.winSize = [60 60];
            obj.parameters.blockSize = [20 20];
            obj.parameters.blockStride = [10 10];
            obj.parameters.cellSize = [10 10];
        end
        %----------------------------------------------
        % train
        function obj = train(obj)
            hogDetect('train', posInputDir, negInputDir, obj.modelName);
        end
        %----------------------------------------------
        % detect
        function [bbox,conf] = detect(obj, I)
            [bbox,conf] = hogDetect('detect', obj.modelName, I);
        end
        %----------------------------------------------
        % save
        function obj = save(obj)
            xml_write(obj.modelName, obj.parameters);
        end
        %----------------------------------------------
        % load
        function obj = load(obj)
            obj.parameters = xml_read(obj.modelName);
        end
        %----------------------------------------------
        % setPosDir
        function obj = setPosDir(obj,s)
            obj.posDir = s;
        end
        %----------------------------------------------
        % getPosDir
        function s = getPosDir(obj)
            s = obj.posDir;
        end
        %----------------------------------------------
        % setNegDir
        function obj = setNegDir(obj,s)
            obj.negDir = s;
        end
        %----------------------------------------------
        % getNegDir
        function s = getNegDir(obj)
            s = obj.negDir;
        end
        %----------------------------------------------
        % setModelName
        function obj = setModelName(obj,s)
            obj.modelName = s;
        end
        %----------------------------------------------
        % getModelName
        function s = getModelName(obj)
            s = obj.modelName;
        end
        %----------------------------------------------
        % setParameters
        function obj = setParameters(obj,para)
            obj.parameters = para;
        end
        %----------------------------------------------
        % getParameters
        function para = getParameters(obj)
            para = obj.parameters;
        end
        %----------------------------------------------
    end
end