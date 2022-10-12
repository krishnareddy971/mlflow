
CREATE TABLE alembic_version (
	version_num VARCHAR(32) COLLATE "SQL_Latin1_General_CP1_CI_AS" NOT NULL,
	CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num)
)


CREATE TABLE experiments (
	experiment_id BIGINT NOT NULL,
	name VARCHAR(256) COLLATE "SQL_Latin1_General_CP1_CI_AS" NOT NULL,
	artifact_location VARCHAR(256) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	lifecycle_stage VARCHAR(32) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	creation_time BIGINT,
	last_update_time BIGINT,
	CONSTRAINT experiment_pk PRIMARY KEY (experiment_id)
)


CREATE TABLE registered_models (
	name VARCHAR(256) COLLATE "SQL_Latin1_General_CP1_CI_AS" NOT NULL,
	creation_time BIGINT,
	last_updated_time BIGINT,
	description VARCHAR(5000) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	CONSTRAINT registered_model_pk PRIMARY KEY (name)
)


CREATE TABLE experiment_tags (
	key VARCHAR(250) COLLATE "SQL_Latin1_General_CP1_CI_AS" NOT NULL,
	value VARCHAR(5000) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	experiment_id BIGINT NOT NULL,
	CONSTRAINT experiment_tag_pk PRIMARY KEY (key, experiment_id),
	CONSTRAINT "FK__experimen__exper__4E88ABD4" FOREIGN KEY(experiment_id) REFERENCES experiments (experiment_id)
)


CREATE TABLE model_versions (
	name VARCHAR(256) COLLATE "SQL_Latin1_General_CP1_CI_AS" NOT NULL,
	version INTEGER NOT NULL,
	creation_time BIGINT,
	last_updated_time BIGINT,
	description VARCHAR(5000) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	user_id VARCHAR(256) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	current_stage VARCHAR(20) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	source VARCHAR(500) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	run_id VARCHAR(32) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	status VARCHAR(20) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	status_message VARCHAR(500) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	run_link VARCHAR(500) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	CONSTRAINT model_version_pk PRIMARY KEY (name, version),
	CONSTRAINT "FK__model_vers__name__571DF1D5" FOREIGN KEY(name) REFERENCES registered_models (name) ON UPDATE CASCADE
)


CREATE TABLE registered_model_tags (
	key VARCHAR(250) COLLATE "SQL_Latin1_General_CP1_CI_AS" NOT NULL,
	value VARCHAR(5000) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	name VARCHAR(256) COLLATE "SQL_Latin1_General_CP1_CI_AS" NOT NULL,
	CONSTRAINT registered_model_tag_pk PRIMARY KEY (key, name),
	CONSTRAINT "FK__registered__name__5AEE82B9" FOREIGN KEY(name) REFERENCES registered_models (name) ON UPDATE CASCADE
)


CREATE TABLE runs (
	run_uuid VARCHAR(32) COLLATE "SQL_Latin1_General_CP1_CI_AS" NOT NULL,
	name VARCHAR(250) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	source_type VARCHAR(20) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	source_name VARCHAR(500) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	entry_point_name VARCHAR(50) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	user_id VARCHAR(256) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	status VARCHAR(9) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	start_time BIGINT,
	end_time BIGINT,
	deleted_time BIGINT,
	source_version VARCHAR(50) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	lifecycle_stage VARCHAR(20) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	artifact_uri VARCHAR(200) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	experiment_id BIGINT,
	deleted_time BIGINT,
	CONSTRAINT run_pk PRIMARY KEY (run_uuid),
	CONSTRAINT "FK__runs__experiment__3D5E1FD2" FOREIGN KEY(experiment_id) REFERENCES experiments (experiment_id)
)


CREATE TABLE latest_metrics (
	key VARCHAR(250) COLLATE "SQL_Latin1_General_CP1_CI_AS" NOT NULL,
	value FLOAT NOT NULL,
	timestamp BIGINT,
	step BIGINT NOT NULL,
	is_nan BIT NOT NULL,
	run_uuid VARCHAR(32) COLLATE "SQL_Latin1_General_CP1_CI_AS" NOT NULL,
	CONSTRAINT latest_metric_pk PRIMARY KEY (key, run_uuid),
	CONSTRAINT "FK__latest_me__run_u__5165187F" FOREIGN KEY(run_uuid) REFERENCES runs (run_uuid)
)


CREATE TABLE metrics (
	key VARCHAR(250) COLLATE "SQL_Latin1_General_CP1_CI_AS" NOT NULL,
	value FLOAT NOT NULL,
	timestamp BIGINT NOT NULL,
	run_uuid VARCHAR(32) COLLATE "SQL_Latin1_General_CP1_CI_AS" NOT NULL,
	step BIGINT DEFAULT ('0') NOT NULL,
	is_nan BIT DEFAULT ('0') NOT NULL,
	CONSTRAINT metric_pk PRIMARY KEY (key, timestamp, step, run_uuid, value, is_nan),
	CONSTRAINT "FK__metrics__run_uui__4316F928" FOREIGN KEY(run_uuid) REFERENCES runs (run_uuid)
)


CREATE TABLE model_version_tags (
	key VARCHAR(250) COLLATE "SQL_Latin1_General_CP1_CI_AS" NOT NULL,
	value VARCHAR(5000) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	name VARCHAR(256) COLLATE "SQL_Latin1_General_CP1_CI_AS" NOT NULL,
	version INTEGER NOT NULL,
	CONSTRAINT model_version_tag_pk PRIMARY KEY (key, name, version),
	CONSTRAINT "FK__model_version_ta__5DCAEF64" FOREIGN KEY(name, version) REFERENCES model_versions (name, version) ON UPDATE CASCADE
)


CREATE TABLE params (
	key VARCHAR(250) COLLATE "SQL_Latin1_General_CP1_CI_AS" NOT NULL,
	value VARCHAR(500) COLLATE "SQL_Latin1_General_CP1_CI_AS" NOT NULL,
	run_uuid VARCHAR(32) COLLATE "SQL_Latin1_General_CP1_CI_AS" NOT NULL,
	CONSTRAINT param_pk PRIMARY KEY (key, run_uuid),
	CONSTRAINT "FK__params__run_uuid__45F365D3" FOREIGN KEY(run_uuid) REFERENCES runs (run_uuid)
)


CREATE TABLE tags (
	key VARCHAR(250) COLLATE "SQL_Latin1_General_CP1_CI_AS" NOT NULL,
	value VARCHAR(5000) COLLATE "SQL_Latin1_General_CP1_CI_AS",
	run_uuid VARCHAR(32) COLLATE "SQL_Latin1_General_CP1_CI_AS" NOT NULL,
	CONSTRAINT tag_pk PRIMARY KEY (key, run_uuid),
	CONSTRAINT "FK__tags__run_uuid__403A8C7D" FOREIGN KEY(run_uuid) REFERENCES runs (run_uuid)
)
