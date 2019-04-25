% read data
mainpath = './data/modelnet40_ply_hdf5_2048';

data_path = strcat( mainpath, '/*.h5');
data_files = dir(data_path);

mkdir data/modelnet40_ply_hdf5_2048_randomID;


NUM_CLASS = 40;

for n=1:length(data_files)
    data_path = strcat( mainpath, '/',data_files(n).name);

%     h5disp(data_path);
    data = h5read(data_path,'/data');
    faceId = h5read(data_path,'/faceId');
    label_real = h5read(data_path,'/label');
    normal = h5read(data_path,'/normal');
    
    size = length(label_real(1,:));
    
    label = randi([0 NUM_CLASS-1],1,size)
    
    processing = data_files(n).name;

    out_path = strcat('data/modelnet40_ply_hdf5_2048_randomID/', data_files(n).name);

    info = h5info(data_path);

%     Dataspace_data = info.Datasets(1).Dataspace.Size;
    ChunkSize_data = info.Datasets(1).ChunkSize;

    Dataspace_faceId = info.Datasets(2).Dataspace.Size;
    ChunkSize_faceId = info.Datasets(2).ChunkSize;

    Dataspace_label = info.Datasets(3).Dataspace.Size;
    ChunkSize_label = info.Datasets(3).ChunkSize;

    Dataspace_normal = info.Datasets(4).Dataspace.Size;
    ChunkSize_normal = info.Datasets(4).ChunkSize;
    
    x = length(data(:, 1, 1));
    y = length(data(1, :, 1));
    z = length(data(1, 1, :));

    h5create(out_path,'/data',[x y z],'Datatype','single','ChunkSize', [ChunkSize_data], 'Deflate', 4);
    h5write(out_path,'/data',data);

    h5create(out_path,'/faceId',[Dataspace_faceId],'Datatype','int32','ChunkSize', [ChunkSize_faceId],'Deflate', 1);
    h5write(out_path,'/faceId',faceId);

    h5create(out_path,'/label',[Dataspace_label],'Datatype','uint8','ChunkSize', [ChunkSize_label],'Deflate', 1);
    h5write(out_path,'/label',label);
    
    h5create(out_path,'/label_real',[Dataspace_label],'Datatype','uint8','ChunkSize', [ChunkSize_label],'Deflate', 1);
    h5write(out_path,'/label_real',label_real);

    h5create(out_path,'/normal',[Dataspace_normal],'Datatype','single','ChunkSize', [ChunkSize_normal],'Deflate', 4);
    h5write(out_path,'/normal',normal);

%     h5disp(out_path);
end
