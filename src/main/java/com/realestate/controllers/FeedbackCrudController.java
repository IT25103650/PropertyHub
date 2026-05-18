package com.realestate.controllers;

import com.realestate.models.ReviewEntity;
import com.realestate.services.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/feedback")
public class FeedbackCrudController {

    @Autowired
    private ReviewService reviewService;

    @GetMapping
    public String listFeedback(Model model, HttpSession session) {
        if(session.getAttribute("userId") == null) return "redirect:/login";
        List<ReviewEntity> list = reviewService.getAllFeedback();
        model.addAttribute("feedbackList", list);
        model.addAttribute("totalFeedback", list.size());
        return "FeedbackManagement/feedback-list";
    }

    @GetMapping("/{id}")
    public String viewFeedback(@PathVariable("id") int id, Model model, HttpSession session) {
        if(session.getAttribute("userId") == null) return "redirect:/login";
        model.addAttribute("feedback", reviewService.getFeedbackById(id).orElse(null));
        return "FeedbackManagement/feedback-detail";
    }

    @GetMapping("/create")
    public String createFeedbackForm(Model model, HttpSession session) {
        if(session.getAttribute("userId") == null) return "redirect:/login";
        model.addAttribute("feedback", new ReviewEntity());
        return "FeedbackManagement/feedback-form";
    }

    @GetMapping("/edit/{id}")
    public String editFeedbackForm(@PathVariable("id") int id, Model model, HttpSession session) {
        if(session.getAttribute("userId") == null) return "redirect:/login";
        model.addAttribute("feedback", reviewService.getFeedbackById(id).orElse(null));
        return "FeedbackManagement/feedback-form";
    }

    @PostMapping("/save")
    public String saveFeedback(@ModelAttribute ReviewEntity feedback, HttpSession session) {
        if(session.getAttribute("userId") == null) return "redirect:/login";
        if(feedback.getReviewerId() == null) feedback.setReviewerId(Integer.parseInt(session.getAttribute("userId").toString()));
        reviewService.createFeedback(feedback);
        return "redirect:/feedback";
    }

    @PostMapping("/update/{id}")
    public String updateFeedback(@PathVariable("id") int id, @ModelAttribute ReviewEntity feedback, HttpSession session) {
        if(session.getAttribute("userId") == null) return "redirect:/login";
        reviewService.updateFeedback(id, feedback.getRating(), feedback.getReviewText(), Integer.parseInt(session.getAttribute("userId").toString()));
        return "redirect:/feedback";
    }

    @GetMapping("/approve/{id}")
    public String approveFeedback(@PathVariable("id") int id, HttpSession session) {
        if(session.getAttribute("userId") == null) return "redirect:/login";
        reviewService.approveFeedback(id);
        return "redirect:/feedback";
    }

    @GetMapping("/reject/{id}")
    public String rejectFeedback(@PathVariable("id") int id, HttpSession session) {
        if(session.getAttribute("userId") == null) return "redirect:/login";
        reviewService.rejectFeedback(id);
        return "redirect:/feedback";
    }

    @GetMapping("/delete/{id}")
    public String deleteFeedback(@PathVariable("id") int id, HttpSession session) {
        if(session.getAttribute("userId") == null) return "redirect:/login";
        reviewService.deleteFeedback(id);
        return "redirect:/feedback";
    }
}

