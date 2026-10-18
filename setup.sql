USE [master]
GO
/****** Object:  Database [AMHS]    Script Date: 10/17/2026 4:40:44 PM ******/
CREATE DATABASE [AMHS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'AMHS', FILENAME = N'D:\Software\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\AMHS.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'AMHS_log', FILENAME = N'D:\Software\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\AMHS_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [AMHS] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AMHS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [AMHS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [AMHS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [AMHS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [AMHS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [AMHS] SET ARITHABORT OFF 
GO
ALTER DATABASE [AMHS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [AMHS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [AMHS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [AMHS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [AMHS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [AMHS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [AMHS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [AMHS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [AMHS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [AMHS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [AMHS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [AMHS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [AMHS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [AMHS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [AMHS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [AMHS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [AMHS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [AMHS] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [AMHS] SET  MULTI_USER 
GO
ALTER DATABASE [AMHS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [AMHS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [AMHS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [AMHS] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [AMHS] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [AMHS] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [AMHS] SET QUERY_STORE = OFF
GO
USE [AMHS]
GO
/****** Object:  User [PLC]    Script Date: 10/17/2026 4:40:45 PM ******/
CREATE USER [PLC] FOR LOGIN [PLC] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [PLC]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [PLC]
GO
/****** Object:  Table [dbo].[equipment]    Script Date: 10/17/2026 4:40:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[equipment](
	[equip_id] [varchar](20) NOT NULL,
	[equip_name] [varchar](100) NULL,
	[current_equip_state] [varchar](20) NULL,
	[former_equip_state] [varchar](20) NULL,
	[current_lot_id] [varchar](20) NULL,
	[former_lot_id] [varchar](20) NULL,
	[upd_dt] [datetime] NULL,
	[current_station_id] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[equip_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[event_history]    Script Date: 10/17/2026 4:40:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[event_history](
	[event_id] [varchar](50) NOT NULL,
	[request_id] [varchar](50) NULL,
	[equip_id] [varchar](20) NULL,
	[start_dt] [datetime] NULL,
	[end_dt] [datetime] NULL,
	[source_location] [varchar](20) NULL,
	[destination_location] [varchar](20) NULL,
	[request_client] [varchar](50) NULL,
	[event_type] [varchar](50) NULL,
	[time_taken_seconds] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[event_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lot]    Script Date: 10/17/2026 4:40:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lot](
	[lot_id] [varchar](20) NOT NULL,
	[product_name] [varchar](50) NULL,
	[lot_status] [varchar](20) NULL,
	[create_dt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[lot_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[request_details]    Script Date: 10/17/2026 4:40:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[request_details](
	[request_id] [varchar](50) NOT NULL,
	[operating_start_dt] [datetime] NULL,
	[operating_end_dt] [datetime] NULL,
	[equip_id] [varchar](20) NULL,
	[target_location] [varchar](20) NULL,
	[home_location] [varchar](20) NULL,
	[request_state] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[request_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[station]    Script Date: 10/17/2026 4:40:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[station](
	[station_id] [varchar](20) NOT NULL,
	[station_name] [varchar](50) NULL,
	[station_type] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[station_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_equip_current_lot]    Script Date: 10/17/2026 4:40:45 PM ******/
CREATE NONCLUSTERED INDEX [IX_equip_current_lot] ON [dbo].[equipment]
(
	[current_lot_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_equip_current_station]    Script Date: 10/17/2026 4:40:45 PM ******/
CREATE NONCLUSTERED INDEX [IX_equip_current_station] ON [dbo].[equipment]
(
	[current_station_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_event_equip]    Script Date: 10/17/2026 4:40:45 PM ******/
CREATE NONCLUSTERED INDEX [IX_event_equip] ON [dbo].[event_history]
(
	[equip_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_event_request]    Script Date: 10/17/2026 4:40:45 PM ******/
CREATE NONCLUSTERED INDEX [IX_event_request] ON [dbo].[event_history]
(
	[request_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_request_equip]    Script Date: 10/17/2026 4:40:45 PM ******/
CREATE NONCLUSTERED INDEX [IX_request_equip] ON [dbo].[request_details]
(
	[equip_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[equipment]  WITH CHECK ADD FOREIGN KEY([current_station_id])
REFERENCES [dbo].[station] ([station_id])
GO
ALTER TABLE [dbo].[event_history]  WITH CHECK ADD FOREIGN KEY([destination_location])
REFERENCES [dbo].[station] ([station_id])
GO
ALTER TABLE [dbo].[event_history]  WITH CHECK ADD FOREIGN KEY([equip_id])
REFERENCES [dbo].[equipment] ([equip_id])
GO
ALTER TABLE [dbo].[event_history]  WITH CHECK ADD FOREIGN KEY([request_id])
REFERENCES [dbo].[request_details] ([request_id])
GO
ALTER TABLE [dbo].[event_history]  WITH CHECK ADD FOREIGN KEY([source_location])
REFERENCES [dbo].[station] ([station_id])
GO
ALTER TABLE [dbo].[request_details]  WITH CHECK ADD FOREIGN KEY([equip_id])
REFERENCES [dbo].[equipment] ([equip_id])
GO
ALTER TABLE [dbo].[request_details]  WITH CHECK ADD FOREIGN KEY([home_location])
REFERENCES [dbo].[station] ([station_id])
GO
ALTER TABLE [dbo].[request_details]  WITH CHECK ADD FOREIGN KEY([target_location])
REFERENCES [dbo].[station] ([station_id])
GO
ALTER TABLE [dbo].[equipment]  WITH CHECK ADD  CONSTRAINT [CK_equip_state] CHECK  (([current_equip_state]='MAINTENANCE' OR [current_equip_state]='CHARGING' OR [current_equip_state]='MOVING' OR [current_equip_state]='IDLE'))
GO
ALTER TABLE [dbo].[equipment] CHECK CONSTRAINT [CK_equip_state]
GO
ALTER TABLE [dbo].[event_history]  WITH CHECK ADD  CONSTRAINT [CK_event_type] CHECK  (([event_type]='INSPECTION' OR [event_type]='MAINTENANCE' OR [event_type]='ROUTE_CHANGE' OR [event_type]='LOT_TRANSFER'))
GO
ALTER TABLE [dbo].[event_history] CHECK CONSTRAINT [CK_event_type]
GO
ALTER TABLE [dbo].[lot]  WITH CHECK ADD  CONSTRAINT [CK_lot_status] CHECK  (([lot_status]='CANCELLED' OR [lot_status]='HOLD' OR [lot_status]='COMPLETED' OR [lot_status]='ACTIVE'))
GO
ALTER TABLE [dbo].[lot] CHECK CONSTRAINT [CK_lot_status]
GO
ALTER TABLE [dbo].[request_details]  WITH CHECK ADD  CONSTRAINT [CK_request_state] CHECK  (([request_state]='CANCELLED' OR [request_state]='COMPLETED' OR [request_state]='IN_PROGRESS' OR [request_state]='ASSIGNED' OR [request_state]='PENDING'))
GO
ALTER TABLE [dbo].[request_details] CHECK CONSTRAINT [CK_request_state]
GO
USE [master]
GO
ALTER DATABASE [AMHS] SET  READ_WRITE 
GO
