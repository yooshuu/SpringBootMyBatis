package kopo.poly.controller;

import kopo.poly.dto.NewsDTO;
import kopo.poly.service.INewsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@Slf4j
@RequestMapping(value = "/news")
@RequiredArgsConstructor
@Controller
public class NewsController {

    private final INewsService newsService;

    @GetMapping(value = "collectNews")
    public String collectNews(ModelMap model) throws Exception {

        log.info("{}.collectNews Start!", this.getClass().getName());

        NewsDTO rDTO = newsService.collectNews(); // Service 호출해서 크롤링 결과 받기

        model.addAttribute("rDTO", rDTO); // JSP로 rDTO 전달

        log.info("{}.collectNews End!", this.getClass().getName());

        return "/news/collectNews";
    }
}
