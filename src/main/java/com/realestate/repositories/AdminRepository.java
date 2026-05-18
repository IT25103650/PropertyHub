package com.realestate.repositories;
import com.realestate.models.*;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface for Admin entity data access.
 *
 * Component 05 - Admin Management
 * Developer: [Student 5]
 */
@Repository
public interface AdminRepository extends JpaRepository<AdminEntity, Integer> {

    Optional<AdminEntity> findByEmail(String email);

    @Query("SELECT a FROM AdminEntity a WHERE a.role = 'admin' ORDER BY a.createdAt DESC")
    List<AdminEntity> findAllAdmins();

    boolean existsByEmail(String email);
}
