package com.tms.workshop.repository;

import com.tms.workshop.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    List<User> findByDepartment(String department);

    User findByEmail(String email);
}
