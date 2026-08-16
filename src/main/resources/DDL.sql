-- ============================================================
-- BIENESTAR - MariaDB 10.6.4 Schema
-- UUID Strategy: BINARY(16)
-- Engine: InnoDB | Charset: utf8mb4
-- ============================================================
-- DROP DATABASE bienestar;
CREATE DATABASE IF NOT EXISTS bienestar
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE bienestar;

SELECT * FROM user
-- ------------------------------------------------------------
-- 1. USERS (Identidad / Autenticación)
-- ------------------------------------------------------------
CREATE TABLE user (
    id            BINARY(16) PRIMARY KEY,
    email         VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL, -- BCrypt / Argon2
    role          VARCHAR(50)  NOT NULL,
    verified      BOOLEAN      NOT NULL DEFAULT FALSE,
    active        BOOLEAN      NOT NULL DEFAULT TRUE,
    totp_secret   VARCHAR(255)          DEFAULT NULL,
    created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_user_role CHECK (role IN ('PACIENTE', 'DOCTOR', 'ENTIDAD', 'ADMIN'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- 2. PATIENTS
-- ------------------------------------------------------------
CREATE TABLE patient (
    id             BINARY(16) PRIMARY KEY,
    user_id        BINARY(16) NOT NULL UNIQUE,
    dni            VARCHAR(20) NOT NULL UNIQUE,
    nombres        VARCHAR(100) NOT NULL,
    apellidos      VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    estado_actual  VARCHAR(30) NOT NULL DEFAULT 'BUSCANDO_DOCTOR',
    created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_patients_user FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT chk_patient_estado CHECK (estado_actual IN ('BUSCANDO_DOCTOR', 'EN_REVISION', 'EN_MEDICACION'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_patients_dni ON patient(dni);
CREATE INDEX idx_patients_estado ON patient(estado_actual);

-- ------------------------------------------------------------
-- 3. DOCTORS
-- ------------------------------------------------------------
CREATE TABLE doctor (
    id               BINARY(16) PRIMARY KEY,
    user_id          BINARY(16) NOT NULL UNIQUE,
    dni              VARCHAR(20) NOT NULL UNIQUE,
    cmp              VARCHAR(50) NOT NULL UNIQUE,
    biografia        TEXT,
    es_independiente BOOLEAN NOT NULL DEFAULT FALSE,
    es_dependiente   BOOLEAN NOT NULL DEFAULT FALSE,
    verificado       BOOLEAN NOT NULL DEFAULT FALSE,
    activo           BOOLEAN NOT NULL DEFAULT TRUE,
    disponible       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_doctors_user FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_doctor_dni ON doctor(dni);
CREATE INDEX idx_doctor_cmp ON doctor(cmp);

-- ------------------------------------------------------------
-- 4. ENTITIES (Health Entities / Clinics)
-- ------------------------------------------------------------
CREATE TABLE entity (
    id             BINARY(16) PRIMARY KEY,
    user_id        BINARY(16) NOT NULL UNIQUE,
    ruc            VARCHAR(20) NOT NULL UNIQUE,
    razon_social   VARCHAR(200) NOT NULL,
    tipo_entidad   VARCHAR(50) NOT NULL,
    direccion      VARCHAR(255),
    verificado     BOOLEAN NOT NULL DEFAULT FALSE,
	activo         BOOLEAN NOT NULL DEFAULT TRUE,
    created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_entity_user FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_entity_ruc ON entity(ruc);

-- ------------------------------------------------------------
-- 5. SPECIALTIES
-- ------------------------------------------------------------
CREATE TABLE specialty (
    id          BINARY(16) PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- 6. SYMPTOMS
-- ------------------------------------------------------------
CREATE TABLE symptom (
    id          BINARY(16) PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL UNIQUE,
    categoria   VARCHAR(100),
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- 7. DOCTOR_SPECIALTIES (N:M)
-- ------------------------------------------------------------
CREATE TABLE doctor_specialty (
    id           BINARY(16) PRIMARY KEY,
    doctor_id    BINARY(16) NOT NULL,
    specialty_id BINARY(16) NOT NULL,
    created_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_doc_spec_doctor FOREIGN KEY (doctor_id) REFERENCES doctor(id) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT fk_doc_spec_specialty FOREIGN KEY (specialty_id) REFERENCES specialty(id) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT uq_doc_specialty UNIQUE (doctor_id, specialty_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_doc_spec_doctor ON doctor_specialty(doctor_id);
CREATE INDEX idx_doc_spec_specialty ON doctor_specialty(specialty_id);

-- ------------------------------------------------------------
-- 8. DOCTOR_SYMPTOMS (Doctores que tratan ciertos síntomas)
-- ------------------------------------------------------------
CREATE TABLE doctor_symptom (
    id         BINARY(16) PRIMARY KEY,
    doctor_id  BINARY(16) NOT NULL,
    symptom_id BINARY(16) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_doc_symp_doctor FOREIGN KEY (doctor_id) REFERENCES doctor(id) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT fk_doc_symp_symptom FOREIGN KEY (symptom_id) REFERENCES symptom(id) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT uq_doc_symptom UNIQUE (doctor_id, symptom_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_doc_symp_doctor ON doctor_symptom(doctor_id);
CREATE INDEX idx_doc_symp_symptom ON doctor_symptom(symptom_id);

-- ------------------------------------------------------------
-- 9. PATIENT_SYMPTOMS (Histórico de síntomas reportados por paciente)
-- ------------------------------------------------------------
CREATE TABLE patient_symptom (
    id            BINARY(16) PRIMARY KEY,
    patient_id    BINARY(16) NOT NULL,
    symptom_id    BINARY(16) NOT NULL,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pat_symp_patient FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT fk_pat_symp_symptom FOREIGN KEY (symptom_id) REFERENCES symptom(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_pat_symp_patient ON patient_symptom(patient_id);
CREATE INDEX idx_pat_symp_fecha ON patient_symptom(fecha_registro);

-- ------------------------------------------------------------
-- 10. CONVERSATIONS
-- Regla de negocio: solo una conversación ACTIVA entre un paciente y un doctor.
-- Se aplica mediante UNIQUE(patient_id, doctor_id, activa)
-- ------------------------------------------------------------
CREATE TABLE conversation (
    id          BINARY(16) PRIMARY KEY,
    patient_id  BINARY(16) NOT NULL,
    doctor_id   BINARY(16) NOT NULL,
    fecha_inicio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activa      BOOLEAN NOT NULL DEFAULT TRUE,
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_conv_patient FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_conv_doctor  FOREIGN KEY (doctor_id) REFERENCES doctor(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT uq_active_conv UNIQUE (patient_id, doctor_id, activa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_conv_patient ON conversation(patient_id);
CREATE INDEX idx_conv_doctor  ON conversation(doctor_id);
CREATE INDEX idx_conv_activa  ON conversation(activa);

-- ------------------------------------------------------------
-- 11. MESSAGES
-- remitente_id contiene el UUID (BINARY) del paciente o doctor.
-- No se define FK porque puede apuntar a dos tablas distintas.
-- ------------------------------------------------------------
CREATE TABLE message (
    id              BINARY(16) PRIMARY KEY,
    conversation_id BINARY(16) NOT NULL,
    remitente_tipo  VARCHAR(20) NOT NULL,
    remitente_id    BINARY(16) NOT NULL, -- UUID del paciente o doctor
    texto           TEXT NOT NULL,
    fecha_hora      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_msg_conversation FOREIGN KEY (conversation_id) REFERENCES conversation(id) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT chk_msg_remitente_tipo CHECK (remitente_tipo IN ('PACIENTE', 'DOCTOR'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_msg_conversation ON message(conversation_id);
CREATE INDEX idx_msg_fecha_hora  ON message(fecha_hora);

-- ------------------------------------------------------------
-- 12. CRONOGRAMAS (Planes de seguimiento)
-- ------------------------------------------------------------
CREATE TABLE cronograma (
    id               BINARY(16) PRIMARY KEY,
    doctor_id        BINARY(16) NOT NULL,
    patient_id       BINARY(16) NOT NULL,
    tipo_cronograma  VARCHAR(20) NOT NULL,
    fecha_creacion   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado           VARCHAR(30) NOT NULL DEFAULT 'PENDIENTE_APROBACION',
    created_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_crono_doctor FOREIGN KEY (doctor_id) REFERENCES doctor(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_crono_patient FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT chk_crono_tipo CHECK (tipo_cronograma IN ('CITA', 'MEDICAMENTO')),
    CONSTRAINT chk_crono_estado CHECK (estado IN ('PENDIENTE_APROBACION', 'ACTIVO', 'RECHAZADO', 'FINALIZADO'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_crono_patient ON cronograma(patient_id);
CREATE INDEX idx_crono_doctor  ON cronograma(doctor_id);
CREATE INDEX idx_crono_estado  ON cronograma(estado);

-- ------------------------------------------------------------
-- 13. CITAS (Detalle para cronograma tipo CITA)
-- ------------------------------------------------------------
CREATE TABLE cita (
    id             BINARY(16) PRIMARY KEY,
    cronograma_id  BINARY(16) NOT NULL UNIQUE, -- 1:1 con cronograma
    fecha_hora     DATETIME NOT NULL,
    lugar          VARCHAR(255),
    notas          TEXT,
    created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_citas_cronograma FOREIGN KEY (cronograma_id) REFERENCES cronograma(id) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_citas_fecha ON cita(fecha_hora);

-- ------------------------------------------------------------
-- 14. MEDICACIONES (Detalle para cronograma tipo MEDICAMENTO)
-- ------------------------------------------------------------
CREATE TABLE medicacion (
    id                 BINARY(16) PRIMARY KEY,
    cronograma_id      BINARY(16) NOT NULL UNIQUE, -- 1:1 con cronograma
    nombre_medicamento VARCHAR(200) NOT NULL,
    presentacion       VARCHAR(100),
    dosis              VARCHAR(100),
    frecuencia         VARCHAR(100),
    fecha_inicio       DATE NOT NULL,
    fecha_fin          DATE NULL,
    created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_med_cronograma FOREIGN KEY (cronograma_id) REFERENCES cronograma(id) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT chk_med_fechas CHECK (fecha_inicio <= fecha_fin OR fecha_fin IS NULL)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_med_cronograma ON medicacion(cronograma_id);

-- ------------------------------------------------------------
-- 15. MEDICATION_LOGS (Cumplimiento)
-- ------------------------------------------------------------
CREATE TABLE medication_log (
    id                     BINARY(16) PRIMARY KEY,
    medicacion_id          BINARY(16) NOT NULL,
    fecha_hora_programada  DATETIME NOT NULL,
    cumplida               BOOLEAN NOT NULL DEFAULT FALSE,
    fecha_hora_realizacion DATETIME NULL,
    created_at             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_mlog_medicacion FOREIGN KEY (medicacion_id) REFERENCES medicacion(id) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_mlog_medicacion ON medication_log(medicacion_id);
CREATE INDEX idx_mlog_fecha_prog  ON medication_log(fecha_hora_programada);
CREATE INDEX idx_mlog_cumplida    ON medication_log(cumplida);

-- ------------------------------------------------------------
-- 16. AFFILIATIONS (Doctor ↔ Entidad)
-- Se usa UNIQUE en (doctor_id, entity_id) para evitar duplicados activos/pendientes.
-- El backend maneja la reactivación.
-- ------------------------------------------------------------
CREATE TABLE affiliation (
    id               BINARY(16) PRIMARY KEY,
    doctor_id        BINARY(16) NOT NULL,
    entity_id        BINARY(16) NOT NULL,
    estado           VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    fecha_solicitud  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_aceptacion DATETIME NULL,
    created_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_aff_doctor FOREIGN KEY (doctor_id) REFERENCES doctor(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_aff_entity FOREIGN KEY (entity_id) REFERENCES entity(id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT chk_aff_estado CHECK (estado IN ('PENDIENTE', 'ACTIVA', 'RECHAZADA', 'INACTIVA')),
    CONSTRAINT uq_aff_doctor_entity UNIQUE (doctor_id, entity_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_aff_doctor ON affiliation(doctor_id);
CREATE INDEX idx_aff_entity ON affiliation(entity_id);
CREATE INDEX idx_aff_estado ON affiliation(estado);

-- ------------------------------------------------------------
-- 17. DEVICE_TOKENS (Push notifications)
-- ------------------------------------------------------------
CREATE TABLE device_token (
    id          BINARY(16) PRIMARY KEY,
    user_id     BINARY(16) NOT NULL,
    token       VARCHAR(255) NOT NULL UNIQUE,
    platform    VARCHAR(20) NOT NULL,
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_dev_user FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT chk_dev_platform CHECK (platform IN ('ANDROID', 'IOS'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_dev_user ON device_token(user_id);

-- ------------------------------------------------------------
-- 18. NOTIFICATIONS (Persistentes para historial y sincronización)
-- ------------------------------------------------------------
CREATE TABLE notification (
    id             BINARY(16) PRIMARY KEY,
    user_id        BINARY(16) NOT NULL,
    tipo           VARCHAR(30) NOT NULL,
    titulo         VARCHAR(255) NOT NULL,
    contenido      TEXT,
    leida          BOOLEAN NOT NULL DEFAULT FALSE,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_lectura  DATETIME NULL,
    CONSTRAINT fk_notif_user FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT chk_notif_tipo CHECK (tipo IN ('MENSAJE', 'CRONOGRAMA', 'CITA', 'MEDICACION', 'ESTADO'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_notif_user_leida ON notification(user_id, leida);
CREATE INDEX idx_notif_fecha ON notification(fecha_creacion);

-- ------------------------------------------------------------
-- 19. NOTIFICATION_PREFERENCES
-- ------------------------------------------------------------
CREATE TABLE notification_preference (
    id                  BINARY(16) PRIMARY KEY,
    user_id             BINARY(16) NOT NULL,
    tipo_notificacion   VARCHAR(30) NOT NULL,
    habilitada          BOOLEAN NOT NULL DEFAULT TRUE,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_pref_user FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT chk_pref_tipo CHECK (tipo_notificacion IN ('MENSAJE', 'CRONOGRAMA', 'CITA', 'MEDICACION', 'ESTADO', 'PUSH_GENERAL')),
    CONSTRAINT uq_pref_user_tipo UNIQUE (user_id, tipo_notificacion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

