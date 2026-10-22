<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String context = request.getContextPath();
    boolean signedIn = session.getAttribute("userId") != null;
    String role = session.getAttribute("role") == null ? "" : String.valueOf(session.getAttribute("role"));
    String dashboard = "STUDENT".equalsIgnoreCase(role) ? context + "/items"
            : "ADMIN".equalsIgnoreCase(role) ? context + "/admin/dashboard"
            : "MODERATOR".equalsIgnoreCase(role) ? context + "/moderator/dashboard" : context + "/items";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="#103f37">
    <meta name="description" content="UniLoop helps your campus community find lost items, borrow essentials, and share resources with verified students.">
    <title>UniLoop — Your campus, shared smarter</title>
    <link rel="stylesheet" href="<%= context %>/home.css">
</head>
<body>
<header class="nav-wrap">
    <nav class="nav container" aria-label="Main navigation">
        <a class="brand" href="<%= context %>/home.jsp" aria-label="UniLoop home">
            <span class="brand-mark">u</span><span>UniLoop<span class="brand-dot">.</span></span>
        </a>
        <div class="nav-links">
            <a href="#how-it-works">How it works</a>
            <a href="#features">Features</a>
        </div>
        <div class="nav-actions">
            <% if (signedIn) { %>
                <a class="button button-quiet" href="<%= dashboard %>">Go to dashboard <span aria-hidden="true">↗</span></a>
            <% } else { %>
                <a class="button button-quiet" href="<%= context %>/auth">Log in</a>
                <a class="button button-small" href="<%= context %>/auth?register=1">Join UniLoop <span aria-hidden="true">↗</span></a>
            <% } %>
        </div>
        <button class="menu-toggle" type="button" aria-label="Open navigation" aria-expanded="false" onclick="toggleMenu(this)">☰</button>
    </nav>
</header>

<main>
    <section class="hero">
        <div class="hero-glow glow-one"></div><div class="hero-glow glow-two"></div>
        <div class="container hero-grid">
            <div class="hero-copy">
                <div class="eyebrow"><span class="live-dot"></span> MADE FOR CAMPUS LIFE</div>
                <h1>Your campus has<br>more to <span class="highlight">share.</span></h1>
                <p class="hero-lead">The easiest way to find what you’ve lost, borrow what you need, and pass useful things on to someone who needs them.</p>
                <div class="hero-actions">
                    <% if (signedIn) { %>
                        <a class="button button-large" href="<%= dashboard %>">Explore your campus <span aria-hidden="true">→</span></a>
                    <% } else { %>
                        <a class="button button-large" href="<%= context %>/auth?register=1">Get started — it’s free <span aria-hidden="true">→</span></a>
                        <a class="text-link" href="<%= context %>/auth">I already have an account</a>
                    <% } %>
                </div>
                <div class="trust-line"><span class="avatar-stack"><i>U</i><i>+</i><i>✓</i></span><span>A more connected campus starts with you.</span></div>
            </div>
            <div class="hero-art" aria-label="Illustration of the UniLoop campus community">
                <div class="art-orbit orbit-a"></div><div class="art-orbit orbit-b"></div>
                <div class="campus-card main-card">
                    <div class="card-top"><span class="mini-logo">u.</span><span class="card-status"><i></i> CAMPUS LOOP</span><span class="dots">•••</span></div>
                    <div class="art-heading">Good things<br>go <em>around.</em></div>
                    <div class="art-illustration">
                        <div class="sun"></div><div class="plant plant-left"><b></b><i></i><span></span></div><div class="plant plant-right"><b></b><i></i><span></span></div>
                        <div class="book book-back"></div><div class="book book-mid"></div><div class="book book-front"><span>SHARE<br>MORE</span></div>
                        <div class="loop-arrow">↻</div>
                    </div>
                    <div class="card-footer"><span>Small acts. Better campus.</span><span class="footer-heart">♥</span></div>
                </div>
                <div class="float-card float-lost"><span class="float-icon icon-coral">⌕</span><span><b>Lost something?</b><small>Bring it back into the loop</small></span><span class="float-arrow">↗</span></div>
                <div class="float-card float-share"><span class="float-icon icon-yellow">↗</span><span><b>Share an extra</b><small>Someone could use it</small></span></div>
                <div class="spark spark-one">✳</div><div class="spark spark-two">✦</div>
            </div>
        </div>
        <div class="container hero-bottom"><span>LESS WASTE</span><span class="bottom-line"></span><span>MORE CONNECTION</span><span class="bottom-line"></span><span>ONE CAMPUS COMMUNITY</span></div>
    </section>

    <section class="feature-section section-pad" id="features">
        <div class="container">
            <div class="section-intro"><div><div class="eyebrow eyebrow-dark">ONE PLACE. MANY POSSIBILITIES.</div><h2>Campus life, <span class="serif-accent">made easier.</span></h2></div><p>From the little things you misplace to the things you can lend, UniLoop keeps helpful campus moments moving.</p></div>
            <div class="feature-grid">
                <article class="feature-card feature-lost"><div class="feature-icon">⌕</div><span class="feature-number">01 / FIND</span><h3>Lost &amp; Found</h3><p>Report something missing or help a classmate reunite with what they’ve found.</p><a href="<%= context %>/auth" class="feature-link">Find your way back <span>↗</span></a><div class="decor-ring ring-one"></div><div class="decor-ring ring-two"></div></article>
                <article class="feature-card feature-borrow"><div class="feature-icon">↔</div><span class="feature-number">02 / BORROW</span><h3>Borrow &amp; Share</h3><p>Need a calculator, book, or campus essential? Connect with people who can help.</p><a href="<%= context %>/auth" class="feature-link">Make a request <span>↗</span></a><div class="borrow-shape">↗</div></article>
                <article class="feature-card feature-community"><div class="feature-icon">◎</div><span class="feature-number">03 / CONNECT</span><h3>Campus community</h3><p>A more thoughtful campus where useful things get a second life and students help students.</p><a href="<%= context %>/auth?register=1" class="feature-link">Join the community <span>↗</span></a><div class="community-orbit">u.</div></article>
            </div>
        </div>
    </section>

    <section class="how-section section-pad" id="how-it-works">
        <div class="container how-grid">
            <div class="how-visual"><div class="how-sticker sticker-top">KEEP IT<br>IN THE LOOP ↗</div><div class="how-circle"><span class="circle-small">UNI</span><span class="circle-big">Loop</span><span class="circle-caption">Give things<br>another go.</span><span class="circle-arrow">↻</span></div><div class="how-sticker sticker-bottom">SHARE A LITTLE.<br>HELP A LOT.</div></div>
            <div class="how-copy"><div class="eyebrow eyebrow-dark">SIMPLE BY DESIGN</div><h2>Good things happen<br>when we <span class="serif-accent">loop together.</span></h2><p class="how-intro">No complicated process. Just a campus community that makes it easier to help each other out.</p>
                <div class="step-list"><div class="step"><span class="step-no">01</span><div><h3>Create your student account</h3><p>Register with your details and submit your student information for verification.</p></div></div><div class="step"><span class="step-no">02</span><div><h3>Find, report, or share</h3><p>Browse campus listings or post an item you’ve lost, found, or can lend.</p></div></div><div class="step"><span class="step-no">03</span><div><h3>Make campus better</h3><p>Connect through useful listings and help resources keep moving around campus.</p></div></div></div>
                <a class="button button-large" href="<%= context %>/auth?register=1">Start your UniLoop journey <span aria-hidden="true">→</span></a>
            </div>
        </div>
    </section>

    <section class="cta-section"><div class="container cta-inner"><div><div class="eyebrow">YOUR CAMPUS. YOUR COMMUNITY.</div><h2>Have something to give?<br><em>Need something back?</em></h2><p>There’s a place for both in the loop.</p></div><% if (signedIn) { %><a class="button button-light button-large" href="<%= dashboard %>">Go to UniLoop <span>↗</span></a><% } else { %><a class="button button-light button-large" href="<%= context %>/auth?register=1">Join UniLoop <span>↗</span></a><% } %></div></section>
</main>
<footer class="footer"><div class="container footer-inner"><a class="brand footer-brand" href="<%= context %>/home.jsp"><span class="brand-mark">u</span><span>UniLoop<span class="brand-dot">.</span></span></a><p>Built on the idea that campus is better when we share.</p><div class="footer-links"><a href="#features">Features</a><a href="#how-it-works">How it works</a><a href="<%= context %>/auth">Student access</a></div><span class="copyright">© <%= java.time.Year.now().getValue() %> UniLoop</span></div></footer>
<script>
function toggleMenu(button) {
    const nav = document.querySelector('.nav');
    const isOpen = nav.classList.toggle('menu-open');
    button.setAttribute('aria-expanded', String(isOpen));
    button.setAttribute('aria-label', isOpen ? 'Close navigation' : 'Open navigation');
}
</script>
</body>
</html>
