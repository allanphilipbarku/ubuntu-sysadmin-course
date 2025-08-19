# Ubuntu System Administration Learning Project

A progressive, collaborative learning platform for Unix system administration skills development.

## 🎯 Project Overview

This is a 10-week intensive system administration learning project designed for collaborative learning through GitHub. Students work independently on practical scenarios while learning from each other through code reviews, discussions, and shared progress tracking.

## 📚 Learning Structure

### 5 Progressive Levels (10 Weeks Total)
- **Level 1**: Foundation - File System and Basic Commands (Weeks 1-2)
- **Level 2**: Services and Process Management (Weeks 3-4)
- **Level 3**: Network Configuration and Monitoring (Weeks 5-6)
- **Level 4**: Storage, Backup, and Performance (Weeks 7-8)
- **Level 5**: Advanced Integration and Automation (Weeks 9-10)

## 🚀 Getting Started

### For Students

1. **Fork this repository** to your own GitHub account
2. **Clone your fork** to your local machine:
   ```bash
   git clone https://github.com/your-username/ubuntu-sysadmin-project.git
   cd ubuntu-sysadmin-project
   ```
3. **Create your student branch**:
   ```bash
   git checkout -b student-[your-github-username]
   ```
4. **Check available tasks** in the current level folder
5. **Work on tasks** and commit your solutions
6. **Submit your work** by creating a Pull Request

### For Teachers

1. **Release new tasks** using the task release system:
   ```bash
   ./scripts/release-tasks.sh level-1 week-1
   ```
2. **Monitor student progress** through the dashboard
3. **Review submissions** and provide feedback through PR reviews

## 📁 Repository Structure

```
ubuntu-sysadmin-project/
├── README.md                          # This file
├── levels/                            # Learning content organized by levels
│   ├── level-1-foundation/           # Level 1: Foundation
│   │   ├── week-1/                   # Week 1 tasks
│   │   ├── week-2/                   # Week 2 tasks
│   │   └── README.md                 # Level overview
│   ├── level-2-services/             # Level 2: Services & Processes
│   ├── level-3-networking/           # Level 3: Networking
│   ├── level-4-storage/              # Level 4: Storage & Performance
│   └── level-5-advanced/             # Level 5: Advanced Integration
├── submissions/                       # Student work submissions
│   └── [username]/                   # Individual student folders
│       ├── level-1/                  # Level 1 submissions
│       ├── level-2/                  # Level 2 submissions
│       └── ...                       # Additional levels
├── scripts/                          # Automation and utility scripts
│   ├── release-tasks.sh              # Task release automation
│   ├── track-progress.sh             # Progress tracking
│   └── setup-environment.sh          # Lab environment setup
├── resources/                        # Shared learning resources
│   ├── references/                   # Reference materials
│   ├── tools/                        # Utility tools and scripts
│   └── templates/                    # Task and submission templates
└── docs/                             # Additional documentation
    ├── CONTRIBUTING.md               # Contribution guidelines
    ├── TEACHER_GUIDE.md              # Teacher instructions
    └── STUDENT_GUIDE.md              # Detailed student guide
```

## 🔄 Workflow

### Student Workflow
1. **Check for new tasks** released by teachers
2. **Work on tasks** in your local environment
3. **Document your solutions** and learning process
4. **Commit and push** your work to your branch
5. **Create Pull Request** for review and submission
6. **Participate in peer reviews** to learn from others

### Teacher Workflow
1. **Release tasks progressively** using automation scripts
2. **Monitor student progress** through GitHub insights
3. **Review student submissions** and provide feedback
4. **Facilitate discussions** and peer learning
5. **Update tasks and content** based on student needs

## 📊 Progress Tracking

- **Individual Progress**: Tracked through commits and PR submissions
- **Peer Learning**: Facilitated through PR reviews and discussions
- **Skills Assessment**: Based on practical demonstrations and portfolio quality
- **Collaboration**: Measured through peer review participation and knowledge sharing

## 🤝 Collaborative Learning Features

- **Peer Reviews**: Students review each other's solutions
- **Discussions**: GitHub Discussions for questions and knowledge sharing
- **Wiki**: Collaborative knowledge base and troubleshooting guides
- **Live Sessions**: Scheduled troubleshooting and demonstration sessions

## 🛠️ Technical Requirements

- Ubuntu 20.04+ or compatible Linux distribution
- Git and GitHub account
- Basic terminal/command line knowledge
- Virtual machine or lab environment (setup scripts provided)

## 📋 Assessment Methods

1. **Practical Demonstrations**: Live troubleshooting sessions
2. **Portfolio Assessment**: Quality of documented solutions
3. **Peer Teaching**: Mentoring and knowledge transfer
4. **Scenario-Based Challenges**: Time-limited problem solving

## 🚨 Getting Help

- **GitHub Issues**: Report problems or ask technical questions
- **Discussions**: General questions and knowledge sharing
- **Wiki**: Check existing solutions and troubleshooting guides
- **Office Hours**: Scheduled sessions with instructors

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

Inspired by Harvard's CS50 collaborative learning model and designed for practical system administration education.

---

**Ready to start your system administration journey? Check out [Level 1](levels/level-1-foundation/) to begin!**