package com.realestate.models;

import java.time.LocalDateTime;

/**
 * Inquiry — shared messaging model between Buyer and Seller.
 *
 * Buyer calls Inquiry.send() to contact a seller about a property.
 * Seller calls Inquiry.reply() to respond.
 * Both Buyer and Seller dashboards call Inquiry.markAsRead().
 */
public class Inquiry {

    private int    inquiryId;
    private int    buyerId;
    private int    sellerId;
    private int    propertyId;
    private String propertyTitle;
    private String buyerName;
    private String message;
    private String replyMessage;
    private boolean isRead;
    private LocalDateTime createdAt;
    private LocalDateTime repliedAt;

    public Inquiry() {
        this.isRead    = false;
        this.createdAt = LocalDateTime.now();
    }

    // ─── SEND (called by Buyer.sendInquiry) ───────────────────────────────────

    /**
     * Creates a new inquiry from a buyer to a seller about a property.
     * Validates that the buyer and property IDs are valid before sending.
     *
     * @return true if inquiry was successfully recorded, false otherwise
     */
    public boolean send(int buyerId, int propertyId, int sellerId, String message) {
        if (buyerId <= 0 || propertyId <= 0 || message == null || message.trim().isEmpty()) {
            System.out.println("[Inquiry] Invalid inquiry data — send aborted.");
            return false;
        }
        this.buyerId    = buyerId;
        this.propertyId = propertyId;
        this.sellerId   = sellerId;
        this.message    = message.trim();
        this.isRead     = false;
        this.createdAt  = LocalDateTime.now();
        System.out.printf("[Inquiry] Inquiry sent: buyer=%d → seller=%d about property=%d%n",
                buyerId, sellerId, propertyId);
        return true;
    }

    // ─── REPLY (called by Seller.replyToInquiry) ──────────────────────────────

    /**
     * Records the seller's reply to this inquiry.
     * Marks the inquiry as read upon successful reply.
     *
     * @return true if reply was recorded
     */
    public boolean reply(String replyMessage) {
        if (replyMessage == null || replyMessage.trim().isEmpty()) {
            System.out.println("[Inquiry] Reply message cannot be empty.");
            return false;
        }
        this.replyMessage = replyMessage.trim();
        this.repliedAt    = LocalDateTime.now();
        this.isRead       = true;
        System.out.printf("[Inquiry] Reply recorded for inquiry #%d%n", inquiryId);
        return true;
    }

    // ─── MARK AS READ ─────────────────────────────────────────────────────────

    /**
     * Marks this inquiry as read.
     * Called when the seller views the inquiry from their dashboard.
     */
    public void markAsRead() {
        this.isRead = true;
        System.out.printf("[Inquiry] Inquiry #%d marked as read.%n", inquiryId);
    }

    // ─── DISPLAY ──────────────────────────────────────────────────────────────

    public void displaySummary() {
        System.out.printf(
            "[Inquiry #%d] From buyer=%d | Property=%d | Read=%b%n  Message: %s%n  Reply: %s%n",
            inquiryId, buyerId, propertyId, isRead,
            message != null ? message : "(none)",
            replyMessage != null ? replyMessage : "(no reply yet)");
    }

    // ─── GETTERS / SETTERS ────────────────────────────────────────────────────

    public int     getInquiryId()    { return inquiryId; }
    public void    setInquiryId(int id) { this.inquiryId = id; }

    public int     getBuyerId()      { return buyerId; }
    public int     getSellerId()     { return sellerId; }
    public int     getPropertyId()   { return propertyId; }
    public String  getMessage()      { return message; }
    public String  getReplyMessage() { return replyMessage; }
    public boolean isRead()          { return isRead; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public LocalDateTime getRepliedAt() { return repliedAt; }
    public String  getBuyerName()    { return buyerName; }
    public void    setBuyerName(String name)     { this.buyerName = name; }
    public String  getPropertyTitle()            { return propertyTitle; }
    public void    setPropertyTitle(String title){ this.propertyTitle = title; }
}

