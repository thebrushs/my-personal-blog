#!/usr/bin/env python3
import os
import re
from datetime import datetime

# 简单的Markdown解析器
def markdown_to_html(markdown):
    # 标题
    markdown = re.sub(r'^# (.*)$', r'<h1>\1</h1>', markdown, flags=re.MULTILINE)
    markdown = re.sub(r'^## (.*)$', r'<h2>\1</h2>', markdown, flags=re.MULTILINE)
    markdown = re.sub(r'^### (.*)$', r'<h3>\1</h3>', markdown, flags=re.MULTILINE)
    
    # 粗体和斜体
    markdown = re.sub(r'\*\*(.*?)\*\*', r'<strong>\1</strong>', markdown)
    markdown = re.sub(r'\*(.*?)\*', r'<em>\1</em>', markdown)
    
    # 链接
    markdown = re.sub(r'\[([^\]]+)\]\(([^\)]+)\)', r'<a href="\2">\1</a>', markdown)
    
    # 列表
    markdown = re.sub(r'^- (.*)$', r'<li>\1</li>', markdown, flags=re.MULTILINE)
    markdown = re.sub(r'(<li>.*?</li>)', r'<ul>\1</ul>', markdown, flags=re.DOTALL)
    
    # 段落
    markdown = re.sub(r'^(?!<h[1-6]>)(?!<ul>)(?!<li>)(.*)$', r'<p>\1</p>', markdown, flags=re.MULTILINE)
    
    return markdown

# 解析Front Matter
def parse_front_matter(content):
    front_matter_match = re.match(r'---\n([\s\S]*?)\n---\n', content)
    if front_matter_match:
        front_matter_text = front_matter_match.group(1)
        content = content[front_matter_match.end():]
        
        front_matter = {}
        for line in front_matter_text.strip().split('\n'):
            if ':' in line:
                key, value = line.split(':', 1)
                front_matter[key.strip()] = value.strip()
        
        return front_matter, content
    return {}, content

# 生成文章页面
def generate_post(front_matter, content, output_path):
    # 解析Markdown为HTML
    html_content = markdown_to_html(content)
    
    # HTML模板
    template = '''
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{title} | My Blog</title>
    <style>
        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }}
        header {{
            border-bottom: 1px solid #eee;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }}
        h1, h2, h3 {{
            color: #2c7a7b;
        }}
        .post-meta {{
            color: #718096;
            font-size: 0.9rem;
            margin-bottom: 20px;
        }}
        .post-content {{
            margin-bottom: 40px;
        }}
        .back-link {{
            display: inline-block;
            margin-top: 20px;
            color: #4fd1c5;
            text-decoration: none;
        }}
        footer {{
            margin-top: 50px;
            padding-top: 20px;
            border-top: 1px solid #eee;
            text-align: center;
            color: #718096;
        }}
    </style>
</head>
<body>
    <header>
        <h1>{title}</h1>
        <div class="post-meta">
            {date} | {author}
        </div>
    </header>
    
    <main>
        <div class="post-content">
            {content}
        </div>
        <a href="/index.html" class="back-link">← 返回首页</a>
    </main>
    
    <footer>
        <p>&copy; {year} My Blog</p>
    </footer>
</body>
</html>
'''
    
    # 填充模板
    html = template.format(
        title=front_matter.get('title', 'Untitled'),
        date=front_matter.get('date', datetime.now().strftime('%Y-%m-%d')),
        author=front_matter.get('author', 'Author'),
        content=html_content,
        year=datetime.now().year
    )
    
    # 写入文件
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(html)

# 生成首页
def generate_index(posts, output_path):
    # 按日期排序（最新的在前）
    posts.sort(key=lambda x: x['date'], reverse=True)
    
    # 生成文章列表HTML
    post_list = ''
    for post in posts:
        post_list += f'''
        <div class="post">
            <h2><a href="/posts/{post['slug']}.html">{post['title']}</a></h2>
            <div class="post-meta">
                {post['date']} | {post['author']}
            </div>
            <div class="post-excerpt">
                {post['excerpt']}...
            </div>
        </div>
        '''
    
    # HTML模板
    template = '''
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Blog</title>
    <style>
        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }}
        header {{
            border-bottom: 1px solid #eee;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }}
        h1, h2 {{
            color: #2c7a7b;
        }}
        .post {{
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }}
        .post h2 a {{
            color: #2c7a7b;
            text-decoration: none;
        }}
        .post-meta {{
            color: #718096;
            font-size: 0.9rem;
        }}
        .post-excerpt {{
            margin-top: 10px;
            color: #4a5568;
        }}
        footer {{
            margin-top: 50px;
            padding-top: 20px;
            border-top: 1px solid #eee;
            text-align: center;
            color: #718096;
        }}
    </style>
</head>
<body>
    <header>
        <h1>My Blog</h1>
        <p>Welcome to my personal blog</p>
    </header>
    
    <main>
        {post_list}
    </main>
    
    <footer>
        <p>&copy; {year} My Blog</p>
    </footer>
</body>
</html>
'''
    
    # 填充模板
    html = template.format(
        post_list=post_list,
        year=datetime.now().year
    )
    
    # 写入文件
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(html)

# 主函数
def main():
    # 获取脚本所在目录的绝对路径
    script_dir = os.path.dirname(os.path.abspath(__file__))
    
    # 确保目录存在
    content_dir = os.path.join(script_dir, 'content')
    public_dir = os.path.join(script_dir, 'public')
    posts_dir = os.path.join(public_dir, 'posts')
    
    os.makedirs(content_dir, exist_ok=True)
    os.makedirs(posts_dir, exist_ok=True)
    
    # 读取content目录下的Markdown文件
    posts = []
    for filename in os.listdir(content_dir):
        if filename.endswith('.md'):
            # 读取文件内容
            file_path = os.path.join(content_dir, filename)
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # 解析Front Matter
            front_matter, markdown_content = parse_front_matter(content)
            
            # 生成slug
            slug = os.path.splitext(filename)[0]
            
            # 生成摘要
            excerpt = markdown_content[:150].strip()
            
            # 生成文章页面
            output_path = os.path.join(public_dir, 'posts', f'{slug}.html')
            generate_post(front_matter, markdown_content, output_path)
            
            # 收集文章信息用于生成首页
            posts.append({
                'title': front_matter.get('title', 'Untitled'),
                'date': front_matter.get('date', datetime.now().strftime('%Y-%m-%d')),
                'author': front_matter.get('author', 'Author'),
                'excerpt': excerpt,
                'slug': slug
            })
    
    # 生成首页
    index_path = os.path.join(public_dir, 'index.html')
    generate_index(posts, index_path)
    
    print(f'Generated {len(posts)} posts and index.html')

if __name__ == '__main__':
    main()