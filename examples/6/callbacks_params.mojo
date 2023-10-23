@value
struct Markdown:
    var content: String

    fn __init__(inout self):
        self.content = ""

    def render_page[f: def() -> object](self, file="none"):
        f()

    fn __ior__(inout self, t: String):
        self.content += t

var md = Markdown()

def readme():
    md |= '''
    # hello mojo
    this is markdown
    ```python
    fn main():
        print("ok")
    ```
    '''
    footer()

def footer():
    md |= '''
    > Page generated
    '''

def main():
    md.render_page[readme](file = "README.md")  # 1
    print(md.content)

# =>
# hello mojo
    # this is markdown
    # ```python
    # fn main():
    #     print("ok")
    # ```
    
    # > Page generated