USE bacula;
--
-- Note, we use BLOB rather than TEXT because in MySQL,
--  BLOBs are identical to TEXT except that BLOB is case
--  sensitive in sorts, which is what we want, and TEXT
--  is case insensitive.
--

CREATE TABLE TagJob
(
   JobId INTEGER UNSIGNED not null,
   Tag   TINYBLOB    not null,
   primary key (JobId, Tag(255))
);

CREATE TABLE TagClient
(
   ClientId INTEGER UNSIGNED not null,
   Tag      TINYBLOB    not null,
   primary key (ClientId, Tag(255))
);

CREATE TABLE TagMedia
(
   MediaId INTEGER UNSIGNED not null,
   Tag      TINYBLOB   not null,
   primary key (MediaId, Tag(255))
);

CREATE TABLE TagObject
(
   ObjectId INTEGER UNSIGNED not null,
   Tag      TINYBLOB    not null,
   primary key (ObjectId, Tag(255))
);

CREATE TABLE Object
(
   ObjectId     BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

   JobId        INTEGER UNSIGNED NOT NULL,
   Path         BLOB NOT NULL,
   Filename     BLOB NOT NULL,
   PluginName   TINYBLOB NOT NULL,

   ObjectCategory  TINYBLOB NOT NULL,
   ObjectType   TINYBLOB     NOT NULL,
   ObjectName   TINYBLOB     NOT NULL,
   ObjectSource TINYBLOB     NOT NULL,
   ObjectUUID   TINYBLOB     NOT NULL,
   ObjectSize   bigint       NOT NULL,
   ObjectStatus BINARY(1) NOT NULL DEFAULT 'U',
   ObjectCount  INTEGER UNSIGNED NOT NULL DEFAULT 1,
   primary key (ObjectId)
);

create index object_jobid_idx on Object (JobId);
create index object_category_idx on Object  (ObjectCategory(255));
create index object_type_idx on Object  (ObjectType(255));
create index object_name_idx on Object  (ObjectName(255));
create index object_source_idx on Object  (ObjectSource(255));

CREATE TABLE Events
(
    EventsId          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    EventsCode        TINYBLOB NOT NULL,
    EventsType        TINYBLOB NOT NULL,
    EventsTime        DATETIME,
    EventsInsertTime  DATETIME,
    EventsDaemon        TINYBLOB NOT NULL,
    EventsSource      TINYBLOB NOT NULL,
    EventsRef         TINYBLOB NOT NULL,
    EventsText        BLOB NOT NULL,
    primary key (EventsId)
);
create index events_time_idx on Events (EventsTime);

CREATE TABLE Path (
   PathId INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
   Path BLOB NOT NULL,
   PRIMARY KEY(PathId),
   INDEX (Path(255))
   );

-- We strongly recommend to avoid the temptation to add new indexes.
-- In general, these will cause very significant performance
-- problems in other areas.  A better approch is to carefully check
-- that all your memory configuation parameters are
-- suitable for the size of your installation.	If you backup
-- millions of files, you need to adapt the database memory
-- configuration parameters concerning sorting, joining and global
-- memory.  By default, sort and join parameters are very small
-- (sometimes 8Kb), and having sufficient memory specified by those
-- parameters is extremely important to run fast.  

-- In File table
-- FileIndex can be 0 for FT_DELETED files
-- FileName can link '' for directories
CREATE TABLE File (
   FileId BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
   FileIndex INTEGER DEFAULT 0,
   JobId INTEGER UNSIGNED NOT NULL,
   PathId INTEGER UNSIGNED NOT NULL,
   Filename BLOB NOT NULL,
   DeltaSeq SMALLINT UNSIGNED DEFAULT 0,
   MarkId INTEGER UNSIGNED DEFAULT 0,
   LStat TINYBLOB NOT NULL,
   MD5 TINYBLOB,
   PRIMARY KEY(FileId),
   INDEX (JobId),
   INDEX (JobId, PathId, Filename(255))
   );

CREATE TABLE RestoreObject (
   RestoreObjectId INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
   ObjectName BLOB NOT NULL,
   RestoreObject LONGBLOB NOT NULL,
   PluginName TINYBLOB NOT NULL,
   ObjectLength INTEGER DEFAULT 0,
   ObjectFullLength INTEGER DEFAULT 0,
   ObjectIndex INTEGER DEFAULT 0,
   ObjectType INTEGER DEFAULT 0,
   FileIndex INTEGER DEFAULT 0,
   JobId INTEGER UNSIGNED NOT NULL,
   ObjectCompression INTEGER DEFAULT 0,
   PRIMARY KEY(RestoreObjectId),
   INDEX (JobId)
   );


#
# Possibly add one or more of the following indexes
#  to the above File table if your Verifies are
#  too slow, but they can slow down backups.
#
#  INDEX (PathId),
#  INDEX (Filename),
#

CREATE TABLE MediaType (
   MediaTypeId INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
   MediaType TINYBLOB NOT NULL,
   ReadOnly TINYINT DEFAULT 0,
   PRIMARY KEY(MediaTypeId)
   );

CREATE TABLE Storage (
   StorageId INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
   Name TINYBLOB NOT NULL,
   AutoChanger TINYINT DEFAULT 0,
   PRIMARY KEY(StorageId)
   );

CREATE TABLE Device (
   DeviceId INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
   Name TINYBLOB NOT NULL,
   MediaTypeId INTEGER UNSIGNED DEFAULT 0,
   StorageId INTEGER UNSIGNED DEFAULT 0,
   DevMounts INTEGER UNSIGNED DEFAULT 0,
   DevReadBytes BIGINT UNSIGNED DEFAULT 0,
   DevWriteBytes BIGINT UNSIGNED DEFAULT 0,
   DevReadBytesSinceCleaning BIGINT UNSIGNED DEFAULT 0,
   DevWriteBytesSinceCleaning BIGINT UNSIGNED DEFAULT 0,
   DevReadTime BIGINT UNSIGNED DEFAULT 0,
   DevWriteTime BIGINT UNSIGNED DEFAULT 0,
   DevReadTimeSinceCleaning BIGINT UNSIGNED DEFAULT 0,
   DevWriteTimeSinceCleaning BIGINT UNSIGNED DEFAULT 0,
   CleaningDate DATETIME,
   CleaningPeriod BIGINT UNSIGNED DEFAULT 0,
   PRIMARY KEY(DeviceId)
   );


CREATE TABLE Job (
   JobId INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
   Job TINYBLOB NOT NULL,
   Name TINYBLOB NOT NULL,
   Type BINARY(1) NOT NULL,
   Level BINARY(1) NOT NULL,
   ClientId INTEGER UNSIGNED DEFAULT 0,
   JobStatus BINARY(1) NOT NULL,
   SchedTime DATETIME,
   StartTime DATETIME,
   EndTime DATETIME,
   RealEndTime DATETIME,
   JobTDate BIGINT UNSIGNED DEFAULT 0,
   VolSessionId INTEGER UNSIGNED DEFAULT 0,
   VolSessionTime INTEGER UNSIGNED DEFAULT 0,
   JobFiles INTEGER UNSIGNED DEFAULT 0,
   JobBytes BIGINT UNSIGNED DEFAULT 0,
   ReadBytes BIGINT UNSIGNED DEFAULT 0,
   JobErrors INTEGER UNSIGNED DEFAULT 0,
   JobMissingFiles INTEGER UNSIGNED DEFAULT 0,
   PoolId INTEGER UNSIGNED DEFAULT 0,
   FileSetId INTEGER UNSIGNED DEFAULT 0,
   PriorJobId INTEGER UNSIGNED DEFAULT 0,
   PriorJob TINYBLOB,
   PurgedFiles TINYINT DEFAULT 0,
   HasBase TINYINT DEFAULT 0,
   HasCache TINYINT DEFAULT 0,
   Reviewed TINYINT DEFAULT 0,
   Comment BLOB,
   FileTable CHAR(20) DEFAULT 'File',
   PRIMARY KEY(JobId),
   INDEX (Name(128))
   );

-- Create a table like Job for long term statistics 
CREATE TABLE JobHisto (
   JobId INTEGER UNSIGNED NOT NULL PRIMARY KEY,
   Job TINYBLOB NOT NULL,
   Name TINYBLOB NOT NULL,
   Type BINARY(1) NOT NULL,
   Level BINARY(1) NOT NULL,
   ClientId INTEGER UNSIGNED DEFAULT 0,
   JobStatus BINARY(1) NOT NULL,
   SchedTime DATETIME,
   StartTime DATETIME,
   EndTime DATETIME,
   RealEndTime DATETIME,
   JobTDate BIGINT UNSIGNED DEFAULT 0,
   VolSessionId INTEGER UNSIGNED DEFAULT 0,
   VolSessionTime INTEGER UNSIGNED DEFAULT 0,
   JobFiles INTEGER UNSIGNED DEFAULT 0,
   JobBytes BIGINT UNSIGNED DEFAULT 0,
   ReadBytes BIGINT UNSIGNED DEFAULT 0,
   JobErrors INTEGER UNSIGNED DEFAULT 0,
   JobMissingFiles INTEGER UNSIGNED DEFAULT 0,
   PoolId INTEGER UNSIGNED DEFAULT 0,
   FileSetId INTEGER UNSIGNED DEFAULT 0,
   PriorJobId INTEGER UNSIGNED DEFAULT 0,
   PriorJob TINYBLOB,
   PurgedFiles TINYINT DEFAULT 0,
   HasBase TINYINT DEFAULT 0,
   HasCache TINYINT DEFAULT 0,
   Reviewed TINYINT DEFAULT 0,
   Comment BLOB,
   FileTable CHAR(20) DEFAULT 'File',
   INDEX (JobId),
   INDEX (StartTime),
   INDEX (JobTDate)
   );

CREATE TABLE Location (
   LocationId INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
   Location TINYBLOB NOT NULL,
   Cost INTEGER DEFAULT 0,
   Enabled TINYINT,
   PRIMARY KEY(LocationId)
   );

CREATE TABLE LocationLog (
   LocLogId INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
   Date DATETIME,
   Comment BLOB NOT NULL,
   MediaId INTEGER UNSIGNED DEFAULT 0,
   LocationId INTEGER UNSIGNED DEFAULT 0,
   NewVolStatus ENUM('Full', 'Archive', 'Append', 'Recycle', 'Purged',
    'Read-Only', 'Disabled', 'Error', 'Busy', 'Used', 'Cleaning') NOT NULL,
   NewEnabled TINYINT,
   PRIMARY KEY(LocLogId)
);

CREATE TABLE FileSet (
   FileSetId INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
   FileSet TINYBLOB NOT NULL,
   MD5 TINYBLOB,
   CreateTime DATETIME,
   PRIMARY KEY(FileSetId)
   );

CREATE TABLE JobMedia (
   JobMediaId INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
   JobId INTEGER UNSIGNED NOT NULL,
   MediaId INTEGER UNSIGNED NOT NULL,
   FirstIndex INTEGER UNSIGNED DEFAULT 0,
   LastIndex INTEGER UNSIGNED DEFAULT 0,
   StartFile INTEGER UNSIGNED DEFAULT 0,
   EndFile INTEGER UNSIGNED DEFAULT 0,
   StartBlock INTEGER UNSIGNED DEFAULT 0,
   EndBlock INTEGER UNSIGNED DEFAULT 0,
   VolIndex INTEGER UNSIGNED DEFAULT 0,
   PRIMARY KEY(JobMediaId),
   INDEX (JobId, MediaId),
   INDEX (MediaId)
   );

CREATE TABLE FileMedia
(
    JobId	      integer	UNSIGNED  not null,
    FileIndex	      integer	UNSIGNED  not null,
    MediaId	      integer	UNSIGNED  not null,
    BlockAddress      bigint	UNSIGNED  default 0,
    RecordNo	      integer	UNSIGNED  default 0,
    FileOffset	      bigint	UNSIGNED  default 0,
    INDEX (JobId, FileIndex),
    FileMediaId   integer auto_increment primary key
);

CREATE TABLE Media (
   MediaId INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
   VolumeName TINYBLOB NOT NULL,
   Slot INTEGER DEFAULT 0,
   PoolId INTEGER UNSIGNED DEFAULT 0,
   MediaType TINYBLOB NOT NULL,
   MediaTypeId INTEGER UNSIGNED DEFAULT 0,
   LabelType TINYINT DEFAULT 0,
   FirstWritten DATETIME,
   LastWritten DATETIME,
   LabelDate DATETIME,
   VolJobs INTEGER UNSIGNED DEFAULT 0,
   VolFiles INTEGER UNSIGNED DEFAULT 0,
   VolBlocks INTEGER UNSIGNED DEFAULT 0,
   VolParts INTEGER UNSIGNED DEFAULT 0,
   VolCloudParts INTEGER UNSIGNED DEFAULT 0,
   VolMounts INTEGER UNSIGNED DEFAULT 0,
   VolBytes BIGINT UNSIGNED DEFAULT 0,
   VolABytes BIGINT UNSIGNED DEFAULT 0,
   VolAPadding BIGINT UNSIGNED DEFAULT 0,
   VolHoleBytes BIGINT UNSIGNED DEFAULT 0,
   VolHoles INTEGER UNSIGNED DEFAULT 0,
   LastPartBytes BIGINT UNSIGNED DEFAULT 0,
   VolType INTEGER UNSIGNED DEFAULT 0,
   VolErrors INTEGER UNSIGNED DEFAULT 0,
   VolWrites BIGINT UNSIGNED DEFAULT 0,
   VolCapacityBytes BIGINT UNSIGNED DEFAULT 0,
   VolStatus ENUM('Full', 'Archive', 'Append', 'Recycle', 'Purged',
    'Read-Only', 'Disabled', 'Error', 'Busy', 'Used', 'Cleaning') NOT NULL,
   Enabled TINYINT DEFAULT 1,
   Recycle TINYINT DEFAULT 0,
   ActionOnPurge     TINYINT	DEFAULT 0,
   CacheRetention BIGINT UNSIGNED DEFAULT 0,
   VolRetention BIGINT UNSIGNED DEFAULT 0,
   VolUseDuration BIGINT UNSIGNED DEFAULT 0,
   MaxVolJobs INTEGER UNSIGNED DEFAULT 0,
   MaxVolFiles INTEGER UNSIGNED DEFAULT 0,
   MaxVolBytes BIGINT UNSIGNED DEFAULT 0,
   InChanger TINYINT DEFAULT 0,
   StorageId INTEGER UNSIGNED DEFAULT 0,
   DeviceId INTEGER UNSIGNED DEFAULT 0,
   MediaAddressing TINYINT DEFAULT 0,
   VolReadTime BIGINT UNSIGNED DEFAULT 0,
   VolWriteTime BIGINT UNSIGNED DEFAULT 0,
   EndFile INTEGER UNSIGNED DEFAULT 0,
   EndBlock INTEGER UNSIGNED DEFAULT 0,
   LocationId INTEGER UNSIGNED DEFAULT 0,
   RecycleCount INTEGER UNSIGNED DEFAULT 0,
   InitialWrite DATETIME,
   ScratchPoolId INTEGER UNSIGNED DEFAULT 0,
   RecyclePoolId INTEGER UNSIGNED DEFAULT 0,
   Comment BLOB,
   PRIMARY KEY(MediaId),
   UNIQUE (VolumeName(128)),
   INDEX (PoolId),
   INDEX (StorageId)
   );

CREATE TABLE Pool (
   PoolId INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
   Name TINYBLOB NOT NULL,
   NumVols INTEGER UNSIGNED DEFAULT 0,
   MaxVols INTEGER UNSIGNED DEFAULT 0,
   UseOnce TINYINT DEFAULT 0,
   UseCatalog TINYINT DEFAULT 0,
   AcceptAnyVolume TINYINT DEFAULT 0,
   VolRetention BIGINT UNSIGNED DEFAULT 0,
   CacheRetention BIGINT UNSIGNED DEFAULT 0,
   VolUseDuration BIGINT UNSIGNED DEFAULT 0,
   MaxVolJobs INTEGER UNSIGNED DEFAULT 0,
   MaxVolFiles INTEGER UNSIGNED DEFAULT 0,
   MaxVolBytes BIGINT UNSIGNED DEFAULT 0,
   MaxPoolBytes BIGINT UNSIGNED DEFAULT 0,
   AutoPrune TINYINT DEFAULT 0,
   Recycle TINYINT DEFAULT 0,
   ActionOnPurge     TINYINT	DEFAULT 0,
   PoolType ENUM('Backup', 'Copy', 'Cloned', 'Archive', 'Migration', 'Scratch') NOT NULL,
   LabelType TINYINT DEFAULT 0,
   LabelFormat TINYBLOB,
   Enabled TINYINT DEFAULT 1,
   ScratchPoolId INTEGER UNSIGNED DEFAULT 0,
   RecyclePoolId INTEGER UNSIGNED DEFAULT 0,
   NextPoolId INTEGER UNSIGNED DEFAULT 0,
   MigrationHighBytes BIGINT UNSIGNED DEFAULT 0,
   MigrationLowBytes BIGINT UNSIGNED DEFAULT 0,
   MigrationTime BIGINT UNSIGNED DEFAULT 0,
   UNIQUE (Name(128)),
   PRIMARY KEY (PoolId)
   );


CREATE TABLE Client (
   ClientId INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
   Name TINYBLOB NOT NULL,
   Uname TINYBLOB NOT NULL,	  /* full uname -a of client */
   AutoPrune TINYINT DEFAULT 0,
   FileRetention BIGINT UNSIGNED DEFAULT 0,
   JobRetention  BIGINT UNSIGNED DEFAULT 0,
   UNIQUE (Name(128)),
   PRIMARY KEY(ClientId)
   );

CREATE TABLE Log (
   LogId INTEGER UNSIGNED AUTO_INCREMENT,
   JobId INTEGER UNSIGNED DEFAULT 0,
   Time DATETIME,
   LogText BLOB NOT NULL,
   PRIMARY KEY(LogId),
   INDEX (JobId)
   );


CREATE TABLE BaseFiles (
   BaseId BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
   BaseJobId INTEGER UNSIGNED NOT NULL,
   JobId INTEGER UNSIGNED NOT NULL,
   FileId BIGINT UNSIGNED NOT NULL,
   FileIndex INTEGER DEFAULT 0,
   PRIMARY KEY(BaseId)
   );

CREATE INDEX basefiles_jobid_idx ON BaseFiles ( JobId );

CREATE TABLE UnsavedFiles (
   UnsavedId INTEGER UNSIGNED AUTO_INCREMENT,
   JobId INTEGER UNSIGNED NOT NULL,
   PathId INTEGER UNSIGNED NOT NULL,
   Filename BLOB NOT NULL,
   PRIMARY KEY (UnsavedId)
   );



CREATE TABLE Counters (
   Counter TINYBLOB NOT NULL,
   `MinValue` INTEGER DEFAULT 0,
   `MaxValue` INTEGER DEFAULT 0,
   CurrentValue INTEGER DEFAULT 0,
   WrapCounter TINYBLOB NOT NULL,
   PRIMARY KEY (Counter(128))
   );

CREATE TABLE CDImages (
   MediaId INTEGER UNSIGNED NOT NULL,
   LastBurn DATETIME,
   PRIMARY KEY (MediaId)
   );

CREATE TABLE Status (
   JobStatus CHAR(1) BINARY NOT NULL,
   JobStatusLong BLOB,
   Severity INT,
   PRIMARY KEY (JobStatus)
   );

INSERT INTO Status (JobStatus,JobStatusLong,Severity) VALUES
   ('C', 'Created, not yet running',15),
   ('R', 'Running',15),
   ('B', 'Blocked',15),
   ('T', 'Completed successfully',10),
   ('E', 'Terminated with errors',25),
   ('e', 'Non-fatal error',20),
   ('f', 'Fatal error',100),
   ('D', 'Verify found differences',15),
   ('A', 'Canceled by user',90),
   ('F', 'Waiting for Client',15),
   ('S', 'Waiting for Storage daemon',15),
   ('m', 'Waiting for new media',15),
   ('M', 'Waiting for media mount',15),
   ('s', 'Waiting for storage resource',15),
   ('j', 'Waiting for job resource',15),
   ('c', 'Waiting for client resource',15),
   ('d', 'Waiting on maximum jobs',15),
   ('t', 'Waiting on start time',15),
   ('p', 'Waiting on higher priority jobs',15),
   ('i', 'Doing batch insert file records',15),
   ('I', 'Incomplete Job',25),
   ('a', 'SD despooling attributes',15);

CREATE TABLE PathHierarchy
(
     PathId INTEGER UNSIGNED NOT NULL,
     PPathId INTEGER UNSIGNED NOT NULL,
     CONSTRAINT pathhierarchy_pkey PRIMARY KEY (PathId)
);

CREATE INDEX pathhierarchy_ppathid 
	  ON PathHierarchy (PPathId);

CREATE TABLE PathVisibility
(
      PathId INTEGER UNSIGNED NOT NULL,
      JobId INTEGER UNSIGNED NOT NULL,
      Size int8 DEFAULT 0,
      Files int4 DEFAULT 0,
      CONSTRAINT pathvisibility_pkey PRIMARY KEY (JobId, PathId)
);
CREATE INDEX pathvisibility_jobid
	     ON PathVisibility (JobId);


CREATE TABLE Snapshot (
  SnapshotId	  INTEGER UNSIGNED AUTO_INCREMENT,
  Name		  TINYBLOB NOT NULL,
  JobId 	  INTEGER  DEFAULT 0,
  FileSetId	  INTEGER DEFAULT 0,
  CreateTDate	  BIGINT   NOT NULL,
  CreateDate	  DATETIME NOT NULL,
  ClientId	  INTEGER DEFAULT 0,
  Volume	  TINYBLOB NOT NULL,
  Device	  TINYBLOB NOT NULL,
  Type		  TINYBLOB NOT NULL,
  Retention	  INTEGER DEFAULT 0,
  Comment	  BLOB,
  primary key (SnapshotId)
);

CREATE UNIQUE INDEX snapshot_idx ON Snapshot (Device(255), 
					      Volume(255),
					      Name(255));



CREATE TABLE Version (
   VersionId INTEGER UNSIGNED NOT NULL PRIMARY KEY
   );

-- Initialize Version
INSERT INTO Version (VersionId) VALUES (1024);

