package com.projects.campify.mailSender.services;

import com.projects.campify.mailSender.models.MailRequest;
import jakarta.mail.MessagingException;

public interface MailService {
    void sendEmail(MailRequest request) throws MessagingException;
}

