function opts = globalOpts()

opts.gt_objID = {'tide', 'sugar', 'red_bowl', 'downy', 'waterpot', 'ranch'};

opts.videoFormat = 'png';
opts.videoPath = 'Videos/';
opts.videoName = 'various_1/';
opts.folder = [opts.videoPath opts.videoName];
opts.img_list = dir(['Videos/' opts.videoName '*.' opts.videoFormat]);
opts.gtName = 'gt/';
opts.inputPath = [opts.videoPath opts.videoName];

end