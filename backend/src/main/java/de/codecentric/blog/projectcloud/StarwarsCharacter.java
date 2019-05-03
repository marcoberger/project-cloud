package de.codecentric.blog.projectcloud;

public class StarwarsCharacter {
    private long id;
    private String name;
    private boolean isJedi;

    public StarwarsCharacter() {
        super();
    }

    public StarwarsCharacter(long id, String name, boolean isJedi) {
        this.id = id;
        this.name = name;
        this.isJedi = isJedi;
    }

    public long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public boolean isJedi() {
        return isJedi;
    }
}
