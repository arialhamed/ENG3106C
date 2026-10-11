-- ============================================================
-- AMHS (Automated Material Handling System) Database Schema
-- Improved design based on examiner feedback
-- ============================================================

-- ============================================================
-- 1. STATION TABLE
--    Defines the production stations in the facility
-- ============================================================
CREATE TABLE station (
    station_id VARCHAR(20) PRIMARY KEY,
    station_name VARCHAR(50),
    station_type VARCHAR(20)
);

-- Insert sample stations
INSERT INTO station (station_id, station_name, station_type) VALUES
('PL01', 'Pilot Line Station 1', 'PRODUCTION'),
('PL02', 'Pilot Line Station 2', 'PRODUCTION'),
('PL03', 'Pilot Line Station 3', 'PRODUCTION'),
('PL04', 'Pilot Line Station 4', 'PRODUCTION'),
('NPI01', 'New Product Introduction 1', 'NPI'),
('NPI02', 'New Product Introduction 2', 'NPI');

-- ============================================================
-- 2. EQUIPMENT TABLE
--    Stores AGV/equipment status
-- ============================================================
CREATE TABLE equipment (
    equip_id VARCHAR(20) PRIMARY KEY,
    equip_name VARCHAR(100),
    current_equip_state VARCHAR(20),
    former_equip_state VARCHAR(20),
    current_lot_id VARCHAR(20),
    former_lot_id VARCHAR(20),
    upd_dt DATETIME,
    -- Foreign key to station (where equipment is currently located)
    current_station_id VARCHAR(20),
    FOREIGN KEY (current_station_id) REFERENCES station(station_id)
);

-- Insert sample equipment
INSERT INTO equipment (equip_id, equip_name, current_equip_state, former_equip_state,
                       current_lot_id, former_lot_id, upd_dt, current_station_id) VALUES
('AGV001', 'Pilot Transfer Cart', 'IDLE', 'MOVING', NULL, 'LOT1001', GETDATE(), 'PL01');

-- ============================================================
-- 3. LOT TABLE
--    Dedicated table for lot tracking (semiconductor flavor)
-- ============================================================
CREATE TABLE lot (
    lot_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(50),
    lot_status VARCHAR(20),
    create_dt DATETIME
);

-- Insert sample lots
INSERT INTO lot (lot_id, product_name, lot_status, create_dt) VALUES
('LOT1001', 'Semiconductor Wafer Lot', 'ACTIVE', DATEADD(DAY, -7, GETDATE())),
('LOT1002', 'Test Module Lot', 'ACTIVE', GETDATE());

-- ============================================================
-- 4. REQUEST TABLE
--    Stores transport requests between stations
-- ============================================================
CREATE TABLE request_table (
    request_id VARCHAR(50) PRIMARY KEY,
    operating_start_dt DATETIME,
    operating_end_dt DATETIME,
    equip_id VARCHAR(20),
    target_location VARCHAR(20),
    home_location VARCHAR(20),
    request_state VARCHAR(20),
    -- Foreign key to equipment
    FOREIGN KEY (equip_id) REFERENCES equipment(equip_id),
    -- Foreign keys to stations
    FOREIGN KEY (target_location) REFERENCES station(station_id),
    FOREIGN KEY (home_location) REFERENCES station(station_id)
);

-- Insert sample requests
INSERT INTO request_table (request_id, operating_start_dt, operating_end_dt,
                           equip_id, target_location, home_location, request_state) VALUES
('REQ0001', GETDATE(), NULL, 'AGV001', 'NPI01', 'PL01', 'PENDING'),
('REQ0002', GETDATE(), NULL, 'AGV001', 'NPI02', 'PL03', 'PENDING');

-- ============================================================
-- 5. EVENT HISTORY TABLE
--    Stores completed job history
-- ============================================================
CREATE TABLE event_history (
    event_id VARCHAR(50) PRIMARY KEY,
    request_id VARCHAR(50),
    equip_id VARCHAR(20),
    start_dt DATETIME,
    end_dt DATETIME,
    source_location VARCHAR(20),
    destination_location VARCHAR(20),
    request_client VARCHAR(50),
    event_type VARCHAR(50),
    time_taken_seconds INT,
    -- Foreign keys
    FOREIGN KEY (request_id) REFERENCES request_table(request_id),
    FOREIGN KEY (equip_id) REFERENCES equipment(equip_id),
    FOREIGN KEY (source_location) REFERENCES station(station_id),
    FOREIGN KEY (destination_location) REFERENCES station(station_id)
);

-- Insert sample event history
INSERT INTO event_history (event_id, request_id, equip_id, start_dt, end_dt,
                           source_location, destination_location, request_client,
                           event_type, time_taken_seconds) VALUES
('EVT0001', 'REQ0001', 'AGV001',
 DATEADD(MINUTE, -5, GETDATE()), GETDATE(),
 'PL01', 'NPI01', 'PilotLineController', 'LOT_TRANSFER', 300),
('EVT0002', 'REQ0002', 'AGV001',
 DATEADD(MINUTE, -7, GETDATE()), DATEADD(MINUTE, -2, GETDATE()),
 'PL03', 'NPI02', 'PilotLineController', 'LOT_TRANSFER', 300);

-- ============================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================
CREATE INDEX IX_equip_current_lot ON equipment(current_lot_id);
CREATE INDEX IX_equip_current_station ON equipment(current_station_id);
CREATE INDEX IX_request_equip ON request_table(equip_id);
CREATE INDEX IX_event_request ON event_history(request_id);
CREATE INDEX IX_event_equip ON event_history(equip_id);

-- ============================================================
-- CHECK CONSTRAINTS FOR CONTROLLED STATE VALUES
-- ============================================================

-- Equipment states
ALTER TABLE equipment
ADD CONSTRAINT CK_equip_state CHECK (current_equip_state IN ('IDLE', 'MOVING', 'CHARGING', 'MAINTENANCE'));

-- Request states
ALTER TABLE request_table
ADD CONSTRAINT CK_request_state CHECK (request_state IN ('PENDING', 'ASSIGNED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED'));

-- Event types
ALTER TABLE event_history
ADD CONSTRAINT CK_event_type CHECK (event_type IN ('LOT_TRANSFER', 'ROUTE_CHANGE', 'MAINTENANCE', 'INSPECTION'));

-- Lot statuses
ALTER TABLE lot
ADD CONSTRAINT CK_lot_status CHECK (lot_status IN ('ACTIVE', 'COMPLETED', 'HOLD', 'CANCELLED'));