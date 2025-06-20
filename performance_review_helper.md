Engineers, if you haven’t finished your self-eval yet and you need some help remembering what you did this last year, try this:
```
gh search prs --author="$(gh api user --jq .login)" --created ">$(date -v-365d +"%Y-%m-%d")" --limit 1000 --json number,title,body,createdAt,repository --template '
{{range .}}
=====================================================
Timestamp:  {{.createdAt}}
Repository: {{.repository.nameWithOwner}}
PR #{{.number}}: {{.title}}

Description:
{{.body}}

{{end}}' > pr_descriptions_fy_2025.txt
```
Then attach that file in Gemini and ask for a summary. This was my prompt:
```
Please summarize my work over the last year. Organize the work by repository, but notice if there are large tasks which cross multiple repositories and seem to be related and call those out as projects.
I'd like a summary which will remind me of all the different kinds of things I worked on so I can write my self-evaluation more easily.
Emphasize the groups of work that seem to have taken a lot of focus, as well as calling out one-off things that sound like they might be high-impact.
```
I tweaked it further by adding the follow specifically tailored to IH's Self Review Questions:
```
More specifically I would like to answer to following questions from my self review form:
- Results Driven: Highlight your key accomplishments and, since We're Here For Outcomes, the results that work drove. Also, note your missed goals, project delays, or what work yielded underperforming results. OKRs and Individual Goal progress can be noted here, as well.
- Strengths: Highlight 1-3 strengths from your work in the past year. Where have you met or exceeded the expectations of your role, and how can you leverage these strengths further? How have you put our Values into action?
- Areas of Opportunity: Outline 1-3 areas of opportunity or development you’re committed to improving in the next year. Note your important work in progress, areas of improvement, and opportunities for impact that move the company or your team forward. Where is there opportunity in how you operate within our Values? Note to managers: Stakeholder feedback is welcome here.
Only help answer where applicable based on my work history.
```
Here's the sample response for when I last ran this:
https://gist.github.com/richddr/86be445fb4cccc972ac29467f1b032cb

# Notes
- Before moving on to my next job, run this report to get all my GH at my current company to generate a summary which I can use to flesh out my resume.

# Additional Resources
- https://jvns.ca/blog/brag-documents/
