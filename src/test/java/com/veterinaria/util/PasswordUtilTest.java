package com.veterinaria.util;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.Test;

class PasswordUtilTest {
    @Test
    void shouldHashAndValidatePassword() {
        String hash = PasswordUtil.hash("admin123");
        assertTrue(PasswordUtil.matches("admin123", hash));
        assertFalse(PasswordUtil.matches("otro", hash));
    }

    @Test
    void shouldSupportLegacyPlainTextPasswords() {
        assertTrue(PasswordUtil.matches("admin123", "admin123"));
        assertTrue(PasswordUtil.isLegacyPlainText("admin123"));
        assertFalse(PasswordUtil.isLegacyPlainText(PasswordUtil.hash("admin123")));
    }
}
