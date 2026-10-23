package com.collegefeedback.filter;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/student/*", "/admin/*", "/faculty/*"})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String uri = req.getRequestURI();
        String role = (session != null) ? (String) session.getAttribute("userRole") : null;

        // Allow login requests to pass through
        if (uri.endsWith("/login") || uri.endsWith("/login.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        if (session == null || role == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Session+expired+or+unauthorized+access.+Please+log+in.");
            return;
        }

        // Role-based path authorization check
        if (uri.contains("/admin/") && !"ADMIN".equalsIgnoreCase(role)) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Unauthorized+Admin+Access");
            return;
        } else if (uri.contains("/student/") && !"STUDENT".equalsIgnoreCase(role)) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Unauthorized+Student+Access");
            return;
        } else if (uri.contains("/faculty/") && !"FACULTY".equalsIgnoreCase(role)) {
            // Allow ADMIN to access faculty actions
            if ("ADMIN".equalsIgnoreCase(role) && uri.contains("/faculty/action")) {
                chain.doFilter(request, response);
                return;
            }
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=Unauthorized+Faculty+Access");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
