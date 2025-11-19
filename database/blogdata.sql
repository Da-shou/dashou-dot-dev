BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "category" (
	"id_category"	INTEGER NOT NULL,
	"name"	TEXT NOT NULL,
	PRIMARY KEY("id_category" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "comment" (
	"id_comment"	INTEGER NOT NULL,
	"author"	TEXT NOT NULL DEFAULT 'Author',
	"content"	TEXT NOT NULL DEFAULT 'Content',
	"timestamp"	TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"id_post"	INT NOT NULL,
	PRIMARY KEY("id_comment" AUTOINCREMENT),
	CONSTRAINT "fk_comment_post" FOREIGN KEY("id_post") REFERENCES "post"("id_post") ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE IF NOT EXISTS "post" (
	"id_post"	INTEGER NOT NULL,
	"title"	TEXT NOT NULL DEFAULT 'Default title',
	"content"	TEXT NOT NULL DEFAULT 'Default description',
	"timestamp"	TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
	"id_category"	INTEGER NOT NULL DEFAULT 1,
	"abstract"	TEXT NOT NULL DEFAULT 'Default abstract',
	"thumbnail"	TEXT,
	PRIMARY KEY("id_post" AUTOINCREMENT),
	CONSTRAINT "fk_post_category" FOREIGN KEY("id_category") REFERENCES "category"("id_category") ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE IF NOT EXISTS "post_has_tag" (
	"id_post"	INTEGER NOT NULL,
	"id_tag"	INTEGER NOT NULL,
	PRIMARY KEY("id_tag","id_post"),
	CONSTRAINT "fk_post_has_tag_post" FOREIGN KEY("id_post") REFERENCES "post"("id_post") ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT "fk_post_has_tag_tag" FOREIGN KEY("id_tag") REFERENCES "tag"("id_tag") ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE IF NOT EXISTS "tag" (
	"id_tag"	INTEGER NOT NULL,
	"name"	TEXT NOT NULL,
	PRIMARY KEY("id_tag" AUTOINCREMENT)
);
INSERT INTO "category" ("id_category","name") VALUES (1,'Programming'),
 (2,'Music'),
 (3,'Sport');
INSERT INTO "comment" ("id_comment","author","content","timestamp","id_post") VALUES (1,'Kazuya','Join my tournament','2025-11-13 14:53:10',1);
INSERT INTO "post" ("id_post","title","content","timestamp","id_category","abstract","thumbnail") VALUES (1,'Learning about pkg-config, GTK and GNU Make','<h2>I like to learn stuff</h2>
<p>One of my favourites things to do in life is to learn about stuff. It might never ever come in handy and I might forget about it after a while, but the feeling of understanding stuff that my brain thought was unintelligible before is an irreplaceable feeling.</p>
<p>So today, I wondered &quot;What should I use to make a GUI application that works on a <em>maximum</em> amount of operting systems ?&quot; Basically, I want to make an application that works under Windows, MacOS and Linux, but also on older version of these systems, for example Windows 7 or even older.</p>
<p>After some research, I ended up on the GTK Project, and more precisely GTK 3. This library is a huge collection of open-source tools made for GUI application development, and is very often used for Linux GUI applications, altough it works on any operating system. On top of that, the main supported language is C, which is one of my favourite language.</p>
<p>The current version of the GTK project at the time of writing is 4.21.2. However I chose to work with GTK 3 as my goal here is to make a small application that works on a majority of operating systems. Also, older versions of GTK such as 2 and 1 do not have any official documentation left.</p>
<p>I like working with older versions of libraries because I can be certain that there will be no changes to the inner workings of it in the future.</p>
<h2>pkg-config is pretty cool</h2>
<p>While working on my personal projects, I really enjoy analyzing the compilation process, even if I don&#39;t get most of it. On the <a href="https://docs.gtk.org/gtk3/compiling.html">&quot;Compiling GTK Applications&quot;</a> page from the official GTK 3 documentation, it starts by informing us that we need to use the pkg-config utility on linux.</p>
<p>This package name rung a bell, but even thought I had heard its name many times before, I still did not understand what it did. So after a few minutes of searching, I found my answers, and I&#39;m really glad I did so !</p>
<p>pkg-config is what its name means. It configures packages, but more precisely, it configures them for compilation with GCC. Basically, for big projects such as GTK, the number of flags you&#39;d have to put became too big and the Makefiles became too messy. Thus, this tool was invented to read a certain type of file that contained all of the standards flags that had to be used with GCC to compile the downloaded package, and each package would give you its pkg-config file. It&#39;s even <a href="https://docs.gtk.org/gtk3/index.html">written on the front  page</a> under &quot;Build&quot;, telling us that the pkg-config file is called <code>gtk+-3.0</code>.</p>
<p>For example, you can use
<code>pkg-config --cflags --libs gtk+-3.0</code>
to get the C compilations flags and the library linkings that we need to compile a project with GTK using GCC.</p>
<p>I also learnt that this tool can be used with the <code>--list-all</code> flag to list all of the libraries present on the system that pkg-config can be used with. So useful ! Now that I knew how to compile an example GTK project, I wanted to have a go at making a Makefile. Ever since I started learning C and C++, I used CMake for every project, and I let it do its things while I tweaked very minor stuff. This time, I&#39;ll try making a good old Makefile for GNU Make. But before compiling anything, we need to write some C, so let&#39;s get to it.</p>
<h2>Writing some GTK flavoured C</h2>
<p>I will be following the first two examples on the <a href="https://docs.gtk.org/gtk3/getting_started.html">Getting started</a> page from the GTK3 documentation.</p>
<p>The code snippets are easy to understand and there are some very nice explanations below them. Interestingly enough, when I tried to compile them by hand (Don&#39;t worry, I will be making a Makefile right after !), it returned a warning about a deprecated macro, which was <code>G_APPLICATION_FLAGS_NONE</code> on line 16 of example-0 and advised me to replace it with <code>G_APPLICATION_DEFAULT_FLAGS</code>, which I did, and the warning went away. Nicely done GTK ! (Also, who formats the code on that website ?! Why would you put one argument per line and then add a line for the opening curly brace ?!)</p>
<p>The two code snippets are very similar, example-0 showing an empty 200x200 window, and example-1 displaying a slightly bigger window with a button that says &quot;Hello World !&quot;. When you click the button, the window closes and returns the same text to the console.</p>
<p>Here is the macro-updated snippet of example-1.</p>
<pre><code class="language-C">#include &lt;gtk/gtk.h&gt; // All GTK applications include this

static void
print_hello (GtkWidget *widget, gpointer data) {
  g_print (&quot;Hello World !\n&quot;);
}

static void
activate (GtkApplication *app, gpointer user_data) {
  GtkWidget *window;
  GtkWidget *button;
  GtkWidget *button_box;

  window = gtk_application_window_new (app);
  gtk_window_set_title (GTK_WINDOW (window), &quot;Hello GUI&quot;);
  gtk_window_set_default_size (GTK_WINDOW (window), 200, 200);

  button_box = gtk_button_box_new (GTK_ORIENTATION_HORIZONTAL);
  gtk_container_add (GTK_CONTAINER (window), button_box);

  button = gtk_button_new_with_label (&quot;Hello World !&quot;);
  g_signal_connect (button, &quot;clicked&quot;, G_CALLBACK (print_hello), NULL);
  g_signal_connect_swapped (button, &quot;clicked&quot;, G_CALLBACK (gtk_widget_destroy), window);
  
  gtk_container_add (GTK_CONTAINER (button_box), button);

  gtk_widget_show_all (window);
}

int main (int argc, char **argv) {
  GtkApplication *app;
  int status;

  app = gtk_application_new (&quot;org.dashou.dev.example&quot;, G_APPLICATION_DEFAULT_FLAGS);
  g_signal_connect (app, &quot;activate&quot;, G_CALLBACK (activate), NULL);
  status = g_application_run (G_APPLICATION (app), argc, argv);
  g_object_unref (app);

  return status;
}
</code></pre>
<h3><code>main</code></h3>
<p>According to the documentation website, the only goal of the <code>main</code> function is to create a <code>gtkApplication</code> and run it. As we can see, that is exactly what is done here with <code>gtk_application_new</code> which takes an ID and a GApplicationFlags (the macro mentioned previously).</p>
<p>Next <code>g_signal_connect</code> connects the &quot;activate&quot; signal to the <code>activate</code> function, written above the main function. This will basically execute the <code>activate</code> function at the start of the program. Then, the application is ran with <code>g_application_run</code>, with its parameters. (Because passing parameters to a GTK application is still possible and useful)</p>
<p>Finally, once the application is done and the status code has been gotten, it is required to free the application from memory using <code>g_object_unref</code>. Basic C.</p>
<h3><code>activate</code></h3>
<p>With what we saw for the main function, this functions reads very easily. Three pointers are created to hold the window, button and button box. The window is first created and configured, then the button box in the same way. The button box is then added to the window with the <code>gtk_container_add</code> function. The exact same pattern happens for the button, however it also gets two signals attached to it.</p>
<p>The first signal is very simple : when the button is clicked, trigger the <code>print_hello</code> function. Easy.</p>
<p>The second is new ! It uses <code>gtk_signal_connect_swapped</code> which allows to pass data to the callback function, in this case being <code>gtk_widget_destroy</code>, and the data being the <code>window</code> pointer. This allows the button to destroy the <strong>window</strong> and not <strong>itself</strong>.</p>
<h3>Just a taste</h3>
<p>We won&#39;t be writing more code than that today ! The goal was to get to know the library and make a small code that I know works so that I can setup a GTK development environment without too much trouble. Now, onto the Makefile so that compiling does not require me to type a 60 character long command each time.</p>
<h2>File named Makefile</h2>
<p>I have very little experience writing Makefile, but if the end result means that I can simply write &quot;make&quot; at the root of my project and see my entire project compiling, then it&#39;s well worth it.</p>
<p>To get to know Makefiles better, I have downloaded the GNU Make Book that is <a href="https://www.gnu.org/software/make/manual/make.pdf">freely available online</a> and read the introductory chapters. I much prefer using books that were written by knowledgeable people first, then look on the internet should I not get certains parts of the book. It&#39;s just how my brain prefers to function. At 2.2 section, there is a great example of a simple Makefile that will do for now. The book is quite old, so it is still using cc instead of gcc, but it simply is a matter of replacing the compiler lines with mine, and here is my minimal Makefile for an example project samed &quot;example-0&quot; using GTK with the help pkg-config.</p>
<pre><code class="language-Makefile">PKG_GTK_NAME = gtk+-3.0
PKG_CONFIG_CFLAGS != pkg-config --cflags $(PKG_GTK_NAME)
PKG_CONFIG_LIBS != pkg-config --libs $(PKG_GTK_NAME)

example-0 : example-0.o example-1
        gcc -o example-0 example-0.o $(PKG_CONFIG_LIBS)

example-0.o : example-0.c
        gcc $(PKG_CONFIG_CFLAGS) -c example-0.c

example-1 : example-1.o
        gcc -o example-1 example-1.o $(PKG_CONFIG_LIBS)

example-1.o : example-1.c
        gcc $(PKG_CONFIG_CFLAGS) -c example-1.c

clean :
        @echo &quot;Cleaning project...&quot;
        rm example-0 example-0.o example-1 example-1.o
</code></pre>
<p>I know, I know, no additional flags, no project name, and so much stuff that you could add to a Makefile. But now I actually know what&#39;s happening, more specifically how Makefile are structured. </p>
<p>Also, the compiling and linking steps are separated and, in my opinion, makes the compiling process clearer. pkg-config is called once for compiling and once for linking. I also learnt that when you call &quot;make&quot;, the first target is always called. Then, inside that target, you can call another one. Here, example-0 is my first target, and it calls the file it needs to compile (example-0.o) and also the following example (example-1). Additionally, I added a &quot;clean&quot; target with removes the executable and object file.</p>
<p>Also, I learnt that using != in Makefiles is a way to assign a variable by executing a shell command. Doing it like this allows us to see each flags that pkg-config returned us every time we call &quot;make&quot;</p>
<p>Because most Makefiles work with variables everywhere, it becomes quite confusing to try to decipher a random Makefile for a project, or one that was generated with CMake for example.</p>
<p>Anyway, this Makefile works perfectly and was a fine exercise to get the basics of Makefiling into my brain !</p>
<h2>Small steps</h2>
<p>So, first blog post. How exciting ! I don&#39;t really know what I&#39;m doing here to be honest, but I will for sure have more interesting things to say for the next posts. However, as I&#39;ve said, I <em>will</em> talk about anything I want here, so feel free to get bored :)</p>
<p>This little GTK session allowed me to discover 3 new tools that I&#39;ve seen used everywhere and I just feel a little less scared of them now, which can only be considered a win.</p>
<p>I think that&#39;s about all I had to say for today. Take care of yourself.</p>','2025-11-19 13:21:50',1,'I decided that it might be fun to look into GTK to learn how to develop portable applications. On the way, I learnt what pkg-config is and refreshed my GNU Make knowledge.','/thumb-2.png');
INSERT INTO "post_has_tag" ("id_post","id_tag") VALUES (1,3),
 (1,4);
INSERT INTO "tag" ("id_tag","name") VALUES (1,'html'),
 (2,'css'),
 (3,'c'),
 (4,'glfw'),
 (5,'cpp');
CREATE INDEX IF NOT EXISTS "fk_comment_post_idx" ON "comment" (
	"id_post"
);
CREATE INDEX IF NOT EXISTS "fk_post_category_idx" ON "post" (
	"id_category"
);
CREATE INDEX IF NOT EXISTS "fk_post_has_tag_post_idx" ON "post_has_tag" (
	"id_post"
);
CREATE INDEX IF NOT EXISTS "fk_post_has_tag_tag_idx" ON "post_has_tag" (
	"id_tag"
);
COMMIT;
