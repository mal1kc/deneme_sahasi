from manim import (
    BLUE,
    GREEN,
    RED,
    PINK,
    ORANGE,
    YELLOW,
    YELLOW_A,
    YELLOW_D,
    UP,
    DOWN,
    LEFT,
    PI,
    RIGHT,
    Circle,
    Create,
    FadeIn,
    FadeOut,
    ReplacementTransform,
    Rotate,
    Scene,
    Square,
    Ellipse,
    Triangle,
    MarkupText,
    Union,
    Group,
    VGroup,
    MathTex,
    Dot,
    Line,
    Exclusion,
    Difference,
    Intersection,
    Text,
    Transform,
    ApplyMethod,
    always_redraw,
)

import numpy as np


class CreateCircle(Scene):
    def construct(self):
        circle = Circle()  # create a circle
        circle.set_fill(PINK, opacity=0.5)  # set the color and transparency
        self.play(Create(circle))  # show the circle on screen


class SquareToCircle(Scene):
    def construct(self):
        circle = Circle()  # create a circle
        circle.set_fill(PINK, opacity=0.5)  # set color and transparency

        square = Square()  # create a square
        square.rotate(PI / 4)  # rotate a certain amount

        self.play(Create(square))  # animate the creation of the square
        # interpolate the square into the circle
        self.play(Transform(square, circle))
        self.play(FadeOut(square))  # fade out animation


class SquareAndCircle(Scene):
    def construct(self):
        circle = Circle()  # create a circle
        circle.set_fill(PINK, opacity=0.5)  # set the color and transparency

        square = Square()  # create a square
        square.set_fill(BLUE, opacity=0.5)  # set the color and transparency

        square.next_to(circle, RIGHT, buff=0.5)  # set the position
        self.play(Create(circle), Create(square))  # show the shapes on screen


class AnimatedSquareToCircle(Scene):
    def construct(self):
        circle = Circle()  # create a circle
        square = Square()  # create a square

        self.play(Create(square))  # show the square on screen
        self.play(square.animate.rotate(PI / 4))  # rotate the square
        self.play(
            ReplacementTransform(square, circle)
        )  # transform the square into a circle
        self.play(
            circle.animate.set_fill(PINK, opacity=0.5)
        )  # color the circle on screen


class DifferentRotations(Scene):
    def construct(self):
        left_square = Square(color=BLUE, fill_opacity=0.7).shift(2 * LEFT)
        right_square = Square(color=GREEN, fill_opacity=0.7).shift(2 * RIGHT)
        self.play(
            left_square.animate.rotate(PI), Rotate(right_square, angle=PI), run_time=2
        )
        self.wait()

        # create in sides of screen right left


class CrashingGears(Scene):
    def there_and_back(self, t):
        return abs(1 - t)

    def construct(self):
        # place side by side with 8 units of space between them 4 - 4
        circle = Circle(color=BLUE, fill_opacity=0.6).shift(4 * LEFT)
        square = Square(color=GREEN, fill_opacity=0.8).shift(4 * RIGHT)
        self.next_section("after_creation")

        # create the shapes
        self.play(Create(circle), Create(square))

        # and crash into each other
        self.play(
            circle.animate.set_fill(BLUE),
            square.animate.set_fill(GREEN),
        )
        self.play(
            circle.animate.shift(RIGHT * 4),
            square.animate.shift(LEFT * 4),
        )

        # then create some particles with removing the shapes
        particles = [
            Triangle().scale(0.2).set_fill(GREEN).move_to(circle.get_center())
            for _ in range(10)
        ]

        # create with random transformations
        particle_transforms = [  # random transformations
            ApplyMethod(
                particle.shift,
                np.random.uniform(-2, 2) * RIGHT + np.random.uniform(-2, 2) * UP,
                rate_func=self.there_and_back,
                run_time=0.9,
            )
            for particle in particles
        ]

        particle_rotations = [
            ApplyMethod(
                particle.rotate,
                np.random.uniform(0, 2 * PI),
                rate_func=self.there_and_back,
                run_time=0.9,
            )
            for particle in particles
        ]
        self.play(
            circle.animate.set_fill(opacity=0),
            square.animate.set_fill(opacity=0),
            circle.animate.scale(0),
            square.animate.scale(0),
            run_time=0.1,
        )

        # play the transformations and rotations ,remove the shapes
        self.play(
            *particle_transforms,
            *particle_rotations,
        )

        self.play(
            *particle_transforms,
        )

        # and then fade out
        self.play(*[FadeOut(pt) for pt in particles])


class BooleanOperations(Scene):
    def construct(self):
        ellipse1 = Ellipse(
            width=4.0, height=5.0, fill_opacity=0.5, color=BLUE, stroke_width=10
        ).move_to(LEFT)
        ellipse2 = ellipse1.copy().set_color(color=RED).move_to(RIGHT)
        bool_ops_text = MarkupText("<u>Boolean Operation</u>").next_to(ellipse1, UP * 3)
        ellipse_group = Group(bool_ops_text, ellipse1, ellipse2).move_to(LEFT * 3)
        self.play(FadeIn(ellipse_group))

        i = Intersection(ellipse1, ellipse2, color=GREEN, fill_opacity=0.5)
        self.play(i.animate.scale(0.25).move_to(RIGHT * 5 + UP * 2.5))
        intersection_text = Text("Intersection", font_size=23).next_to(i, UP)
        self.play(FadeIn(intersection_text))

        u = Union(ellipse1, ellipse2, color=ORANGE, fill_opacity=0.5)
        union_text = Text("Union", font_size=23)
        self.play(u.animate.scale(0.3).next_to(i, DOWN, buff=union_text.height * 3))
        union_text.next_to(u, UP)
        self.play(FadeIn(union_text))

        e = Exclusion(ellipse1, ellipse2, color=YELLOW, fill_opacity=0.5)
        exclusion_text = Text("Exclusion", font_size=23)
        self.play(
            e.animate.scale(0.3).next_to(u, DOWN, buff=exclusion_text.height * 3.5)
        )
        exclusion_text.next_to(e, UP)
        self.play(FadeIn(exclusion_text))

        d = Difference(ellipse1, ellipse2, color=PINK, fill_opacity=0.5)
        difference_text = Text("Difference", font_size=23)
        self.play(
            d.animate.scale(0.3).next_to(u, LEFT, buff=difference_text.height * 3.5)
        )
        difference_text.next_to(d, UP)
        self.play(FadeIn(difference_text))


class SineCurveUnitCircle(Scene):
    # contributed by heejin_park, https://infograph.tistory.com/230
    def construct(self):
        self.show_axis()
        self.show_circle()
        self.move_dot_and_draw_curve()
        self.wait()

    def show_axis(self):
        x_start = np.array([-6, 0, 0])
        x_end = np.array([6, 0, 0])

        y_start = np.array([-4, -2, 0])
        y_end = np.array([-4, 2, 0])

        x_axis = Line(x_start, x_end)
        y_axis = Line(y_start, y_end)

        self.add(x_axis, y_axis)
        self.add_x_labels()

        self.origin_point = np.array([-4, 0, 0])
        self.curve_start = np.array([-3, 0, 0])

    def add_x_labels(self):
        x_labels = [
            MathTex("\pi"),
            MathTex("2 \pi"),
            MathTex("3 \pi"),
            MathTex("4 \pi"),
        ]

        for i in range(len(x_labels)):
            x_labels[i].next_to(np.array([-1 + 2 * i, 0, 0]), DOWN)
            self.add(x_labels[i])

    def show_circle(self):
        circle = Circle(radius=1)
        circle.move_to(self.origin_point)
        self.add(circle)
        self.circle = circle

    def move_dot_and_draw_curve(self):
        orbit = self.circle
        origin_point = self.origin_point

        dot = Dot(radius=0.08, color=YELLOW)
        dot.move_to(orbit.point_from_proportion(0))
        self.t_offset = 0
        rate = 0.25

        def go_around_circle(mob, dt):
            self.t_offset += dt * rate
            # print(self.t_offset)
            mob.move_to(orbit.point_from_proportion(self.t_offset % 1))

        def get_line_to_circle():
            return Line(origin_point, dot.get_center(), color=BLUE)

        def get_line_to_curve():
            x = self.curve_start[0] + self.t_offset * 4
            y = dot.get_center()[1]
            return Line(
                dot.get_center(), np.array([x, y, 0]), color=YELLOW_A, stroke_width=2
            )

        self.curve = VGroup()
        self.curve.add(Line(self.curve_start, self.curve_start))

        def get_curve():
            last_line = self.curve[-1]
            x = self.curve_start[0] + self.t_offset * 4
            y = dot.get_center()[1]
            new_line = Line(last_line.get_end(), np.array([x, y, 0]), color=YELLOW_D)
            self.curve.add(new_line)

            return self.curve

        dot.add_updater(go_around_circle)

        origin_to_circle_line = always_redraw(get_line_to_circle)
        dot_to_curve_line = always_redraw(get_line_to_curve)
        sine_curve_line = always_redraw(get_curve)

        self.add(dot)
        self.add(orbit, origin_to_circle_line, dot_to_curve_line, sine_curve_line)
        self.wait(8.5)

        dot.remove_updater(go_around_circle)
