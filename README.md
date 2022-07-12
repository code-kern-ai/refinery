![](https://uploads-ssl.webflow.com/61e47fafb12bd56b40022a49/62c2f30f935f4d37dc864eeb_Kern%20refinery.png)

<p align="center">
    <b>Open-source data-centric IDE for NLP. Combining programmatic/manual labeling, extensive data management and neural search capabilities.</b>
</p>

<p align=center>
    <a href="https://github.com/code-kern-ai/refinery/blob/master/LICENSE"><img src="https://img.shields.io/badge/License-Apache%202.0-success" alt="Apache 2.0 License"></a>
    <a href="https://discuss.kern.ai/"><img src="https://img.shields.io/badge/Forum-F5D14E.svg?logo=discourse" alt="Discourse"></a>
    <a href="https://discord.gg/qf4rGCEphW"><img src="https://img.shields.io/badge/Discord-gray.svg?logo=discord" alt="Discord"></a>
    <a href="https://twitter.com/MeetKern"><img src="https://img.shields.io/badge/Twitter-white.svg?logo=twitter" alt="Twitter"></a>
    <a href="https://www.linkedin.com/company/kern-ai"><img src="https://img.shields.io/badge/LinkedIn-0A66C2.svg?logo=linkedin" alt="LinkedIn"></a>
    <a href="https://www.youtube.com/channel/UCru-6X24b76TRsL6KWMFEFg"><img src="https://img.shields.io/badge/YouTube-FF0000.svg?logo=youtube" alt="YouTube"></a>
    <a href="https://github.com/code-kern-ai/refinery/projects/1"><img src="https://img.shields.io/badge/Roadmap-yellow.svg" alt="Roadmap"></a>
    <a href="https://app.kern.ai/"><img src="https://img.shields.io/badge/Cloud-Kern AI-75EA8E.svg?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAeCAYAAABNChwpAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAALDSURBVHgBvVfBjRUxDLWzf+GCxJeQkLhNJ2wLFIC02wFIcNgG4IBAdMCBBrYD6IS5oYXLcoAL/Bg7iRM7Mx+ElMHSTDxOxn52nMRBKPR4vvwAQA8BELOE+EGQD8QAIYkRgjzMiwyl5WGh8NKXZFD6y1jpP0Jz15ONYzGNRSQtUZYrNBKBPPqn4RDRaSVYEuV/pwYgeEVUYyAtHVW0ZqgoT+5Y4JYUZAMQdSBWr1GVkgGnfegVQZWRjxomScWOHZyw9IKqB8WdPK/FG3lZUOkLdUqsHKrraIKg0RSd8s+uByAIyQSbzV8R4k1KwJIhWKOQEw+InxDq/wlpKJoEOdKeRWcs2WefGoid9x2hm+n5/fTiEQyg59ev37H6817upgBN+7eE+1ciaMmi4e8A+NC7zBlAbJS679S6HOgzFGF7Citcs45jIeCKvt2Tzy8nYb79/M4Zm5dcjJGzPt7wPM0wkGTe7RJPq+D05PYn+bgXbhmEePXq/tMLGEhsOKm3URAwwaLZksISUNlH/hOl4HfhXwBzW/BoKkd2b89vRGuoRmLoABydggjbkEbYroZdP2B0YkilxX5P1z++7k8C6hH98e7pnYsKgOqRm0M0MgJinJuJWOuv2OqEtw8uZ+lPzubDATajXBXh6iFXp2DLbaBURQZOo7BYerTNKqh7LAbnarBns44cvQpaeaaVdMOwy6j6+NP5sy9vUuLIT3w4Mcdtqgdj0iGyxAPkN+XRkQ5JdogHMbNnftIyrSt1GwBnuqwIZs4gKWyzljMYa6EqvC3ZiWIto0OJbL1okJb5fspdDuQ1Wopzbf2rITGHmivbiy0yhfiftvjQ1/VaFVHRa0vwasR/Y7vM1TtFKompFPE26D2U1XtBVmwuIOhimMfRcmHZ61muQn122aC1CADOsEK0YBC05FeACzLXjxbHPu/FapiV/Q23LD/8UGO+6AAAAABJRU5ErkJggg==" alt="Kern AI"></a>
    <a href="https://docs.kern.ai/docs"><img src="https://img.shields.io/badge/Docs-blue.svg" alt="Docs"></a>
    <a href="https://www.kern.ai/"><img src="https://img.shields.io/badge/Website-white.svg" alt="Website"></a>
</p>

Kern AI refinery (abbr. _refinery_) is like the data-centric sibling of your favorite programming environment. It provides an easy-to-use interface for weak supervision, a technique to integrate heuristics for automated data labeling. The workflow enables you to manually and programmatically label data efficiently, such that you can focus on what matters most.

![](https://uploads-ssl.webflow.com/61e47fafb12bd56b40022a49/62c305d6b1aa5da5154ff7b7_sample-screenshot.png)

refinery consists of multiple microservices to enable a scalable and optimized workload balance, so this is the central repository used to orchestrate the system. It builds on top of [🤗 Hugging Face](https://www.huggingface.co) and [spaCy](https://spacy.io/) to leverage pre-built language models for your NLP tasks. Our microservices natively support GPU acceleration.

## 🧑‍💻 Built for developers
There are already many other labeling tools out there, so why did we decide to build *yet another one*? Easy: we believe that there is a lack of *open-source, developer-oriented* tools for data-centric NLP. In other terms: developers and scientists should be able to participate in the refinement of raw data to training data, but with the programmatic approach they love. **The benefits**: you gain better insights into the data labeling workflow, receive an implicit documentation for your training data, and can ultimately build better models in shorter time.

Our goal is to make labeling feel more like a programmatic and enjoyable task, instead of something tedious and repetitive. *refinery* is our contribution to this goal. And we're constantly aiming to improve this contribution.

If you like what we're working on, please leave a ⭐! 

## 🐳 Installation via Docker
*refinery* consists of multiple services that need to be run together. To do so, we've set up a `docker-compose` file, which will automatically pull and connect the respective services for you. The file is part of this repository, so you can just clone it and run `docker-compose up -d`. After some minutes (now is a good time to grab a coffee ☕), the setup is done and you can access `http://localhost:4455` in your browser.

## 📘 Documentation and sample projects
The best way to start with refinery is our [quick start](https://docs.kern.ai/v1.0/docs/quickstart).

You can find extensive guides in our [README docs](https://docs.kern.ai/docs), and some [tutorials](https://www.youtube.com/channel/UCru-6X24b76TRsL6KWMFEFg/videos) on our YouTube channel.

We've also prepared some projects which you can download and import to your local application. Go to our [sample projects repository](https://github.com/code-kern-ai/sample-projects), where you can select from multiple projects.

## 🪢 Community and contact
Please join our community spaces [Discord](https://discord.gg/qf4rGCEphW) and [our forum](https://discuss.kern.ai/), and/or follow us on [Twitter](https://twitter.com/MeetKern) and [LinkedIn](https://www.linkedin.com/company/kern-ai).

To reach out via email, please contact [info@kern.ai](mailto:info@kern.ai).

## 🗺️ Roadmap
Our goal is to provide you with an easy-to-use, yet powerful open-source tool, which helps you to build the best training data for your model. We'll focus on the following high-level tasks:
- [ ] Further labeling task options in the area of NLP
- [ ] Extensive user-, label- and data-management capabilities
- [ ] Improving the developer experience continuously
- [ ] Continuously making the whole system more efficient to provide you with realtime insights
- [ ] Providing you with great content to learn more about data-centric AI and how to implement it in *refinery*
- [ ] Integrations to your favorite ML frameworks and applications

You can find our short- to midterm feature plans in the [public roadmap](https://github.com/code-kern-ai/refinery/projects/1)

## 🙌 Contributing
Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**. You can do so by providing feedback about bugs or generally technical issues you might detect. If you actively want to participate in extending the code base, reacht out to us. We'll explain you how the architecture is set up, so you can customize the application as you desire.

If you have a suggestion for features, please [create a ticket in our forum](https://discuss.kern.ai/c/enhancements/6). If you find a bug, please open an [issue](https://github.com/code-kern-ai/refinery/issues) and choose the tag "bug".

## 🐍 Python SDK
You can extend your projects by using our [Python SDK](https://github.com/code-kern-ai/kern-python). With it, you can easily export labeled data of your current project and import new files both programmatically and via CLI (`kern pull` and `kern push <file_name>`). It also comes with adapters, e.g. to [Rasa](https://github.com/RasaHQ/rasa).

## 📃 License
Kern AI refinery is licensed under the Apache License, Version 2.0. View a copy of the [License file](LICENSE).
