package com.veterinaria.model;

import java.math.BigDecimal;

public class DetalleComprobante {
    private int idDetalleComprobante;
    private int idComprobante;
    private String tipoItem;
    private Integer idProducto;
    private String descripcion;
    private int cantidad;
    private BigDecimal precioUnitario;
    private BigDecimal subtotal;

    public int getIdDetalleComprobante() {
        return idDetalleComprobante;
    }

    public void setIdDetalleComprobante(int idDetalleComprobante) {
        this.idDetalleComprobante = idDetalleComprobante;
    }

    public int getIdComprobante() {
        return idComprobante;
    }

    public void setIdComprobante(int idComprobante) {
        this.idComprobante = idComprobante;
    }

    public String getTipoItem() {
        return tipoItem;
    }

    public void setTipoItem(String tipoItem) {
        this.tipoItem = tipoItem;
    }

    public Integer getIdProducto() {
        return idProducto;
    }

    public void setIdProducto(Integer idProducto) {
        this.idProducto = idProducto;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
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
