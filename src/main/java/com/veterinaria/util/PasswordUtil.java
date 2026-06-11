package com.veterinaria.util;

import org.mindrot.jbcrypt.BCrypt;

public final class PasswordUtil {
    private PasswordUtil() {
    }

    public static String hash(String plainText) {
        return BCrypt.hashpw(plainText, BCrypt.gensalt(12));
    }

    public static boolean matches(String plainText, String storedValue) {
        if (plainText == null || storedValue == null || storedValue.isBlank()) {
            return false;
        }
        if (storedValue.startsWith("$2a$") || storedValue.startsWith("$2b$") || storedValue.startsWith("$2y$")) {
            return BCrypt.checkpw(plainText, storedValue);
        }
        return plainText.equals(storedValue);
    }

    public static boolean isLegacyPlainText(String storedValue) {
        return storedValue != null
                && !storedValue.startsWith("$2a$")
                && !storedValue.startsWith("$2b$")
                && !storedValue.startsWith("$2y$");
    }
}
