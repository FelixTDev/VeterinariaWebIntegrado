package com.veterinaria.model;

import java.math.BigDecimal;

public class DetalleAtencionProducto {
    private int idDetalleAtencion;
    private int idAtencion;
    private int idProducto;
    private String productoNombre;
    private int cantidad;
    private String dosis;
    private String indicaciones;
    private BigDecimal precioUnitario;
    private BigDecimal subtotal;

    public int getIdDetalleAtencion() {
        return idDetalleAtencion;
    }

    public void setIdDetalleAtencion(int idDetalleAtencion) {
        this.idDetalleAtencion = idDetalleAtencion;
    }

    public int getIdAtencion() {
        return idAtencion;
    }

    public void setIdAtencion(int idAtencion) {
        this.idAtencion = idAtencion;
    }

    public int getIdProducto() {
        return idProducto;
    }

    public void setIdProducto(int idProducto) {
        this.idProducto = idProducto;
    }

    public String getProductoNombre() {
        return productoNombre;
    }

    public void setProductoNombre(String productoNombre) {
        this.productoNombre = productoNombre;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public String getDosis() {
        return dosis;
    }

    public void setDosis(String dosis) {
        this.dosis = dosis;
    }

    public String getIndicaciones() {
        return indicaciones;
    }

    public void setIndicaciones(String indicaciones) {
        this.indicaciones = indicaciones;
    }

    public BigDecimal getPrecioUnitario() {
        return precioUnitario;
    }

    public void setPrecioUnitario(BigDecimal precioUnitario) {
        this.precioUnitario = precioUnitario;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }
}
