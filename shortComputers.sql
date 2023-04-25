USE my_computers;

CREATE TABLE computer (
    id INT AUTO_INCREMENT,
    board VARCHAR(100),
    cpu_type VARCHAR(100),
    ram_amount VARCHAR(100),
    gpu VARCHAR(100),
    disk_amount VARCHAR(100),
    disk_type VARCHAR(100),
    optic_disk VARCHAR(100),
    os VARCHAR(100),
    monitor_resolution VARCHAR(100),
    PRIMARY KEY (id)
);

INSERT INTO computer(board, cpu_type, ram_amount, gpu, disk_amount, disk_type, optic_disk, os, monitor_resolution) 
VALUES ('Asus', 'Intel i7', '16GB', 'Nvidia 3080 GTX','2000GB', 'SDD', 'Yes', 'Windows', '4K');

INSERT INTO computer(board, cpu_type, ram_amount, gpu, disk_amount, disk_type, optic_disk, os, monitor_resolution) 
VALUES ('Sapphire', 'AMD R7', '12GB', 'Nvidia 7000 GT','1500GB', 'SDD', 'No', 'Windows', 'FullHD');

INSERT INTO computer(board, cpu_type, ram_amount, gpu, disk_amount, disk_type, optic_disk, os, monitor_resolution) 
VALUES ('GigaByte', 'Intel i5', '8GB', 'Nvidia Geforce 920','1000GB', 'HDD', 'Yes', 'Linux', 'HD');

SELECT * FROM computer 