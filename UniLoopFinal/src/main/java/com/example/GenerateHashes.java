
package com.example;

import org.mindrot.jbcrypt.BCrypt;

public class GenerateHashes {
    public static void main(String[] args) {

        System.out.println("ADMIN:");
        System.out.println(BCrypt.hashpw("Admin@123", BCrypt.gensalt()));

        System.out.println("MODERATOR:");
        System.out.println(BCrypt.hashpw("Mod@123", BCrypt.gensalt()));

        System.out.println("STUDENT:");
        System.out.println(BCrypt.hashpw("Student@123", BCrypt.gensalt()));
    }
}
