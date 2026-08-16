package io.owl.bienestar.entity;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EntityRepository extends JpaRepository<Entity, UUID> { }
