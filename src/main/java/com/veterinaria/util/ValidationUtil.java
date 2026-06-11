package com.veterinaria.util;

import com.veterinaria.exception.AppException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Collection;

public final class ValidationUtil {
    private ValidationUtil() {
    }

    public static void require(boolean condition, String message) {
        if (!condition) {
            throw new AppException(message);
        }
    }

    public static void notBlank(String value, String message) {
        require(value != null && !value.trim().isEmpty(), message);
    }

    public static void nonNegative(BigDecimal value, String message) {
        require(value != null && value.signum() >= 0, message);
    }

    public static void positive(Integer value, String message) {
        require(value != null && value > 0, message);
    }

    public static void notNull(Object value, String message) {
        require(value != null, message);
    }

    public static void notEmpty(Collection<?> items, String message) {
        require(items != null && !items.isEmpty(), message);
    }

    public static void futureOrToday(LocalDate date, String message) {
        require(date != null && !date.isBefore(LocalDate.now()), message);
    }
}
